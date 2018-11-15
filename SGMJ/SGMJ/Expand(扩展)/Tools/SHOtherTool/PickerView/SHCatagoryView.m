//
//  SHCatagoryView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCatagoryView.h"

static CGFloat bgViewHeith = 300;
static CGFloat cityPickViewHeigh = 240;
static CGFloat toolsViewHeith = 40;
static CGFloat animationTime = 0.25;

@interface SHCatagoryView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;           //透明背景view
@property (nonatomic, strong) UIView *toolsView;        //工具view
@property (nonatomic, strong) UIButton *sureButton;     //确定按钮
@property (nonatomic, strong) UIButton *cancelButton;   //取消按钮
@property (nonatomic, strong) UIPickerView *cityPickerView;//选择器view

@property (nonatomic, strong) NSMutableDictionary *dic; //数据字典
@property (nonatomic, copy) NSString *leftString;
@property (nonatomic, copy) NSString *rightString;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;

@property (nonatomic, assign) NSInteger selectRow;      //选中的row
@property (nonatomic, copy) NSString *string;           //拼接的字符串

@property (nonatomic, strong) NSArray *otherArray;

@property (nonatomic, strong) NSArray *advertiseArray;

@end


@implementation SHCatagoryView

- (instancetype)initWithDict:(NSMutableDictionary *)dic
{
    if (self = [super init]) {
        _dic = [NSMutableDictionary dictionary];
        _dic = dic;
        
        _leftArray = [_dic allKeys];
        _rightArray = [_dic allValues];
        _rightArray = [_dic objectForKey:_leftArray[0]];
        
        _leftString = _leftArray[0];
        _rightString = _rightArray[0];
        _string = [NSString stringWithFormat:@"%@-%@", _leftArray[0], _rightArray[0]];
        SHLog(@"初始化_string:%@", _string)
    }
    return self;
}

//init会调用initWithFrame
- (instancetype)init
{
    if (self = [super init]) {
        SHLog(@"init")
        
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        self.advertiseArray = array;
        _leftString = @"";
        _rightString = @"";
        _string = array[0];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        SHLog(@"initWithFrame")
        [self stepUI];
        [self initBaseData];
    }
    return self;
}

//初始化UI
- (void)stepUI
{
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.backgroundColor = SH_RGBA(0, 0, 0, 0.5);
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.toolsView];
    [self.toolsView addSubview:self.cancelButton];
    [self.toolsView addSubview:self.sureButton];
    [self.bgView addSubview:self.cityPickerView];
    
    [self showPickView];
}

//初始化数据信息
- (void)initBaseData
{
    SHLog(@"initBaseData")
}



#pragma mark - lazy
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SHScreenH, SHScreenW, bgViewHeith)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIPickerView *)cityPickerView
{
    if (!_cityPickerView) {
        _cityPickerView = ({
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolsViewHeith, SHScreenW, cityPickViewHeigh)];
            pickerView.backgroundColor = [UIColor whiteColor];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            pickerView;
        });
    }
    return _cityPickerView;
}

- (UIView *)toolsView
{
    if (!_toolsView) {
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, toolsViewHeith)];
        _toolsView.layer.borderWidth = 0.5;
        _toolsView.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return _toolsView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, toolsViewHeith)];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
            cancelButton;
        });
    }
    return _cancelButton;
}

- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = ({
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(SHScreenW - 20 - 50, 0, 50, toolsViewHeith)];
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton setTitleColor:navColor forState:UIControlStateNormal];
            [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            sureButton;
        });
    }
    return _sureButton;
}


#pragma mark - private methods
//取消按钮
- (void)cancelButtonClick
{
    [self hidePickView];
}

//确定按钮
- (void)sureButtonClick
{
    
    [self hidePickView];
    
    if (self.catagoarySelectBlock) {
        SHLog(@"%@-%@-%@", _leftString, _rightString, _string)
        self.catagoarySelectBlock(_leftString, _rightString, _string);
    }
    
}

//show选择器
- (void)showPickView
{
    [UIView animateWithDuration:animationTime animations:^{
        self.bgView.frame = CGRectMake(0, SHScreenH - bgViewHeith, SHScreenW, bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}

//hide选择器
- (void)hidePickView
{
    [UIView animateWithDuration:animationTime animations:^{
        self.bgView.frame = CGRectMake(0, SHScreenH, SHScreenW, bgViewHeith);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches.anyObject.view isKindOfClass:[self class]]) {
        [self hidePickView];
    }
}


#pragma amrk - pickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type == SHSexSelectType) {
        return 1;
    } else if (self.type == SHAdvertisementType) {
        return 1;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.type == SHSexSelectType) {
        return _advertiseArray.count;
    } else if (self.type == SHAdvertisementType) {
        return _advertiseArray.count;
    }
    
    else {
        if (component == 0) {
            return _leftArray.count;
        } else if (component == 1) {
            //        NSArray *array = _leftArray[component];
            if (_rightArray.count > 0) {
                return _rightArray.count;
            } else {
                return 0;
            }
        }
    }
    
    return 0;
}

#pragma mark - pickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SHScreenW *component / 3, 30)];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    
    if (self.type == SHSexSelectType) {
        label.text = _advertiseArray[row];
    } else if (self.type == SHAdvertisementType) {
        label.text = _advertiseArray[row];
    }
    
    else {
        if (component == 0) {
            label.text = _leftArray[row];
        } else if (component == 1) {
            if (_rightArray.count > 0) {
                label.text = _rightArray[row];
            } else {
                label.text = @"";
            }
            
        }
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.type == SHSexSelectType) {
        _selectRow = row;
        _leftString = @"";
        _rightString = @"";
        _string = _advertiseArray[row];
    } else if (self.type == SHAdvertisementType) {
        _selectRow = row;
        _leftString = @"";
        _rightString = @"";
        _string = _advertiseArray[row];
    }
    
    else {
        if (component == 0) {
            _selectRow = row;
            _leftString = _leftArray[row];
            _rightArray = [_dic objectForKey:_leftArray[_selectRow]];
            if (_rightArray.count > 0) {
                _rightString = _rightArray[0];
            } else {
                _rightString = @"";
            }
            [self.cityPickerView reloadComponent:1];
            [self.cityPickerView selectRow:0 inComponent:1 animated:YES];
        } else if (component == 1) {
            _rightArray = [_dic objectForKey:_leftArray[_selectRow]];
            if (_rightArray.count > 0) {
                _rightString = _rightArray[row];
            } else {
                _rightString = @"";
            }
        }
        
        _string = [NSString stringWithFormat:@"%@-%@", _leftString, _rightString];
    }
    
}


@end




