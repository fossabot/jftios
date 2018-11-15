//
//  SHModifyPayPsdVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHModifyPayPsdVController.h"

@interface SHModifyPayPsdVController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;





@end

@implementation SHModifyPayPsdVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self allTFResignFirstResponder];
    [_codeBtn sh_stopCountDown];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"修改支付密码";
    
    _phoneView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _phoneView.layer.cornerRadius = _phoneView.height / 2;
    _phoneView.clipsToBounds = YES;
    _phoneView.layer.borderWidth = 1;
    _phoneView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _codeView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _codeView.layer.cornerRadius = _codeView.height / 2;
    _codeView.clipsToBounds = YES;
    _codeView.layer.borderWidth = 1;
    _codeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _passwordView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _passwordView.layer.cornerRadius = _passwordView.height / 2;
    _passwordView.clipsToBounds = YES;
    _passwordView.layer.borderWidth = 1;
    _passwordView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    _phoneLabel.text = SH_AppDelegate.personInfo.mobile;
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureButton setBackgroundColor:navColor];
    _sureButton.layer.cornerRadius = _sureButton.height / 2;
    _sureButton.clipsToBounds = YES;
}

/**
 *  验证码
 */
- (IBAction)codeBtnClick:(UIButton *)sender {
    
    if (![NSString isEmpty:_phoneLabel.text]) {
        [sender sh_beginCountDownWithDuration:SHCountDownSeconds];
        [self getUUID];
    }
    
    
}

//验证码之前获取uuid
- (void)getUUID {
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SH_SecretAuthUrl params:nil success:^(id JSON, int code, NSString *msg) {
        if (code == 0) {
            NSDictionary *dict = nil;
            dict = @{
                     @"mobile":_phoneLabel.text,
                     @"type":@"6",
                     @"uuid":JSON[@"uuid"]
                     };
            [weakSelf getCodeFunctionWithDict:dict];
        }
    } failure:^(NSError *error) {
        
    }];
}

//获取验证码接口
- (void)getCodeFunctionWithDict:(NSDictionary *)dict
{
    SHLog(@"%@", dict)
    //获取验证码接口
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMessageUrl params:dict success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%@", msg)
        SHLog(@"%d", code)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"短信已成功发送到您的手机上" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMBPAlertView:@"获取验证码失败" withSecond:2.0];
    }];
}


/**
 *  确认修改
 */
- (IBAction)sureButtonClick:(UIButton *)sender {
    
    if ([self judgeAllParagrams]) {
        SHWeakSelf
        NSDictionary *dic = @{
                              @"code":_codeTF.text,
                              @"newPass":_passwordTF.text
                              };
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHModifyPayPsdUrl params:dic success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", msg)
            if (code == 0) {
                [MBProgressHUD showMBPAlertView:@"修改成功" withSecond:2.0];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    
}

- (BOOL)judgeAllParagrams
{
    if ([NSString isEmpty:_phoneLabel.text]) {
        [MBProgressHUD showMBPAlertView:@"手机号为空" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_codeTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入验证码" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_passwordTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入新的支付密码" withSecond:2.0];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
//位数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if ([textField isEqual:_codeTF]) {
        return textField.text.length < SHCodeLength;
    } else if ([textField isEqual:_passwordTF]) {
        return textField.text.length < SHCodeLength;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if (textField == _passwordTF) {
        _passwordView.layer.borderColor = [SHColorFromHex(0x3d6b90) CGColor];
        _codeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    if (textField == _codeTF) {
        _codeView.layer.borderColor = [SHColorFromHex(0x3d6b90) CGColor];
        _passwordView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self allTFResignFirstResponder];
    return YES;
}

- (void)allTFResignFirstResponder {
    [_passwordTF resignFirstResponder];
    [_codeTF resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTFResignFirstResponder];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
