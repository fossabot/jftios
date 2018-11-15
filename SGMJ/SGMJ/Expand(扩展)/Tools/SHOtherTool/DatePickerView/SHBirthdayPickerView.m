//
//  SHBirthdayPickerView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/15.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHBirthdayPickerView.h"

@interface SHBirthdayPickerView ()
//<UIPickerViewDelegate, UIPickerViewDataSource>
{
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
}


@property (nonatomic, strong) UIView *contentV;             //pickerView所在的view
@property (nonatomic, strong) UIPickerView *pickerView;     //pickerView

@property (nonatomic, strong) UIDatePicker *datePicker;     //datePicker
@property (nonatomic,strong)NSArray *subTitles;
@property (nonatomic,assign)NSInteger selectedRow;



@end



@implementation SHBirthdayPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SH_RGBA(0, 0, 0, 0.5);
        self.alpha = 0;
        
        //pickerView所在背景view
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, SHScreenH - 64, SHScreenW, 220)];
        contentV.backgroundColor = SH_WhiteColor;
        [self addSubview:contentV];
        self.contentV = contentV;
        
//        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SHScreenW, 180)];
//        self.pickerView.backgroundColor = SH_WhiteColor;
//        self.pickerView.delegate = self;
//        self.pickerView.dataSource = self;
//        [contentV addSubview:self.pickerView];
//        [self.pickerView selectRow:_selectedRow inComponent:0 animated:YES];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SHScreenW, 180)];
        self.datePicker.backgroundColor = SH_WhiteColor;
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        self.datePicker.locale = [[NSLocale alloc]
                                 initWithLocaleIdentifier:@"zh_CN"];
        [self.datePicker setMaximumDate:[NSDate date]];
        
        [contentV addSubview:self.datePicker];
        
        //盛放按钮的view
        UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 40)];
        upView.backgroundColor = SH_WhiteColor;
        [contentV addSubview:upView];
        
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 40, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.backgroundColor = SH_ClearColor;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitleColor:SH_UIColorFromRGB(0x008dd6) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upView addSubview:cancelButton];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake(SHScreenW - 52, 0, 40, 40);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        chooseButton.backgroundColor = SH_ClearColor;
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [chooseButton setTitleColor:SH_UIColorFromRGB(0x008dd6) forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upView addSubview:chooseButton];
        
        //中间显示文字
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), 0, SHScreenW - 104, 40)];
        _titleLabel.text = @"出生日期";
        [upView addSubview:_titleLabel];
        _titleLabel.textColor = SH_UIColorFromRGB(0x3f4548);
        _titleLabel.font = SH_FontSize(13);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //分割线
        UIView *spliteView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SHScreenW, 0.6)];
        spliteView.backgroundColor = SH_UIColorFromRGB(0xe6e6e6);
        [upView addSubview:spliteView];
        
    }
    return self;
}

//日期转为字符串
- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

#pragma mark - event methods
- (void)cancelButtonClick
{
    [self hidePickerView];
    
}


- (void)configButtonClick
{
    NSString *string = [self dateToString:self.datePicker.date];
    self.selectBlock(string);
    [self hidePickerView];
}


#pragma mark - 隐藏、显示view
- (void)hidePickerView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        _contentV.frame = CGRectMake(0, SHScreenH, SHScreenW, 220);
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, SHScreenH - 64, SHScreenW, SHScreenH - 64);
    }];
}

- (void)showPickerView
{
    //显示pickerView的时候，显示当前时间
    self.frame = CGRectMake(0, 0, SHScreenW, SHScreenH);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        _contentV.frame = CGRectMake(0, SHScreenH - 220 - 64, SHScreenW, 220);
    } completion:^(BOOL finished) {
        
    }];
    
}






@end
