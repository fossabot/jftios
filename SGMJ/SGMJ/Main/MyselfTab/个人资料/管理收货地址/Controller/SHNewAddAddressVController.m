
//
//  SHNewAddAddressVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/9.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHNewAddAddressVController.h"
#import "SH_CitySelected.h"
#import "SHAddressModel.h"

static NSUInteger num = 100;
@interface SHNewAddAddressVController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) SH_CitySelected *cityChoose;

@property (weak, nonatomic) IBOutlet UITextField *receiveNameTF;
@property (weak, nonatomic) IBOutlet UITextField *photoTF;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UITextView *detailAddTextView;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;




@end

@implementation SHNewAddAddressVController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignAllKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
}

- (void)initBaseInfo
{
    if (self.addressType == SHAddressNewAddType) {
        self.navigationItem.title = @"新增收货地址";
    } else if (self.addressType == SHAddressEditType) {
        self.navigationItem.title = @"编辑收货地址";
        
        _receiveNameTF.text = _addressModel.receiveName;
        _photoTF.text = _addressModel.receivePhone;
        _province = _addressModel.province;
        _city = _addressModel.city;
        _area = _addressModel.area;
        [_addressButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", _addressModel.province, _addressModel.city, _addressModel.area] forState:UIControlStateNormal];
        [_addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _descriptionL.hidden = YES;
        _detailAddTextView.text = _addressModel.detailAddress;
        if (_addressModel.isDefault == 0) {
            [_defaultSwitch setOn:NO animated:YES];
        } else {
            [_defaultSwitch setOn:YES animated:YES];
        }
    }
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _saveButton.layer.cornerRadius = _saveButton.height / 2;
    _saveButton.clipsToBounds = YES;
    
}


#pragma mark - buttonClick
//地区选址
- (IBAction)addressButtonClick:(UIButton *)sender {
    [self resignAllKeyboard];
    SHWeakSelf
    self.cityChoose = [[SH_CitySelected alloc] init];
    self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town) {
        [weakSelf.addressButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", province, city, town] forState:UIControlStateNormal];
        [weakSelf.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        weakSelf.province = province;
        weakSelf.city = city;
        weakSelf.area = town;
    };
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:self.cityChoose];
}

//保存修改
- (IBAction)saveButtonClick:(id)sender {
    
    if ([self allSelectedFixed]) {
        [self addNewAddressRequest];
    }
}

- (void)addNewAddressRequest
{
    SHWeakSelf
    NSDictionary *dic = nil;
    NSString *string = nil;
    NSString *url = nil;
    if (self.addressType == SHAddressNewAddType) {
        dic = @{
              @"receiveName":_receiveNameTF.text,
              @"receivePhone":_photoTF.text,
              @"province":_province,
              @"city":_city,
              @"area":_area,
              @"detailAddress":_detailAddTextView.text,
              @"isDefault":_defaultSwitch.on ? @"1" : @"0"
              };
        string = @"添加成功";
        url = SHAddAddressUrl;
    } else if (self.addressType == SHAddressEditType) {
        //编辑地址判断各字段是否发生改变
        dic = @{
                @"addressId":@(_addressModel.ID),
                @"receiveName":_receiveNameTF.text,
                @"receivePhone":_photoTF.text,
                @"province":_province,
                @"city":_city,
                @"area":_area,
                @"detailAddress":_detailAddTextView.text,
                @"isDefault":_defaultSwitch.on ? @"1" : @"0"
                };
        string = @"编辑成功";
        url = SHEditorAddressUrl;
    }
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:url params:dic success:^(id JSON, int code, NSString *msg) {
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:string withSecond:2.0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (BOOL)allSelectedFixed
{
    if ([NSString isEmpty:_receiveNameTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入收货人姓名" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_photoTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入手机号" withSecond:2.0];
        return NO;
    }
    if (![NSString isOKPhoneNumber:_photoTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的手机号" withSecond:2.0];
        return NO;
    }
    if ([_addressButton.titleLabel.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showMBPAlertView:@"请选择所在地区" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_detailAddTextView.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入详细地址" withSecond:2.0];
        return NO;
    }
    return YES;
}



- (void)resignAllKeyboard
{
    [_photoTF resignFirstResponder];
    [_receiveNameTF resignFirstResponder];
    [_detailAddTextView resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if ([textField isEqual:_photoTF]) {
        return textField.text.length < SHPhoneLength;
    }
    return YES;
}

//UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    _detailAddTextView = textView;
    _descriptionL.hidden = YES;
    _numberL.text = [NSString stringWithFormat:@"%ld/100",(long)textView.text.length];
    
    if (_detailAddTextView.text.length >= num) {
        _detailAddTextView.text = [_detailAddTextView.text substringToIndex:num];
    }
    //取消安润点击权限，并显示文字
    if (_detailAddTextView.text.length == 0) {
        _descriptionL.hidden = NO;
    }
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
