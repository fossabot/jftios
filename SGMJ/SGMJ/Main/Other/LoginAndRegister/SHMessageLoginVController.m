//
//  SHMessageLoginVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMessageLoginVController.h"
#import "UIButton+SHButton.h"
#import "SHTabBarController.h"
#import "SHLoginModel.h"

@interface SHMessageLoginVController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;




@end

@implementation SHMessageLoginVController

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background2"] forBarMetrics:UIBarMetricsDefault];
//    //去掉导航栏底部的黑线
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//}
//
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    [self allTFResignFirstResponder];
    [_codeButton sh_stopCountDown];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}

- (void)initBaseInfo {
    
    if (self.loginType == SHMessageLoginType) {
        self.navigationItem.title = @"短信登录";
    } else if (self.loginType == SHBindPhoneType) {
        self.navigationItem.title = @"绑定手机号";
    }
    
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
    
    _loginButton.layer.cornerRadius = _loginButton.height / 2;
    _loginButton.clipsToBounds = YES;
    [_loginButton setBackgroundColor:navColor];
    [_codeButton setTitleColor:SHColorFromHex(0x676975) forState:UIControlStateNormal];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - button
- (IBAction)codeButtonClick:(UIButton *)sender {
    if (![self judgePhone:_phoneTF.text]) {
        
    } else {
        [sender sh_beginCountDownWithDuration:SHCountDownSeconds];
        //获取验证码之前首先获取UUID
        [self getUUID];
        
    }
}

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    SHWeakSelf
    
    if (![self judgePhoneAndCode]) {
        
    } else {
        if (self.loginType == SHMessageLoginType) {
            NSDictionary *dic = @{
                                  @"mobile":_phoneTF.text,
                                  @"city":SH_AppDelegate.personInfo.city,
                                  @"loginType":@"code",
                                  @"code":_codeTF.text,
                                  @"lon":@(SH_AppDelegate.personInfo.longitude),
                                  @"lat":@(SH_AppDelegate.personInfo.latitude)
                                  };
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHLoginUrl params:dic success:^(id JSON, int code, NSString *msg) {
                SHLog(@"%d", code)
                SHLog(@"%@", msg)
                SHLog(@"%@", JSON)
                [MBProgressHUD hideHUDForView:weakSelf.view];
                if (code == 100) {
                    [MBProgressHUD showMBPAlertView:@"您只有先注册才能进行短信登录" withSecond:2.0];
                } else if (code == 0) {
                    //已经注册的用户
                    SHLoginModel *loginModel = [SHLoginModel mj_objectWithKeyValues:JSON];
                    [weakSelf handleUserInfo:loginModel isThreeLogin:NO];
                    [weakSelf uploadRegisterID];
                    //登陆成功通知
                    NSDictionary *dic = JSON;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil userInfo:dic];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutHuanXin object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
                    
                    [MBProgressHUD showMBPAlertView:@"登录成功" withSecond:2.0];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    
                    
                }
            } failure:^(NSError *error) {
                
            }];
        } else if (self.loginType == SHBindPhoneType) {
            //绑定手机号接口
            [self bindPhoneOrNot];
        }
       
        
    }
}

//绑定手机号
- (void)bindPhoneOrNot
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"mobile":_phoneTF.text,
                          @"code":_codeTF.text,
                          @"key":_dic[@"key"],
                          @"avatar":_dic[@"avatar"],
                          @"nickName":_dic[@"nickName"],
                          @"type":_dic[@"type"],
                          @"lon":@(SH_AppDelegate.personInfo.longitude),
                          @"lat":@(SH_AppDelegate.personInfo.latitude)
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHBindPhoneUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"登录成功" withSecond:2.0];
            //存储用户信息
            SHLoginModel *loginModel = [SHLoginModel mj_objectWithKeyValues:JSON];
            [weakSelf handleUserInfo:loginModel isThreeLogin:NO];
            [weakSelf uploadRegisterID];
            //登陆成功通知
            NSDictionary *dic = JSON;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil userInfo:dic];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutHuanXin object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
            
            //返回
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                // 这是从一个模态出来的页面跳到tabbar的某一个页面
            }];
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)handleUserInfo:(SHLoginModel *)loginModel isThreeLogin:(BOOL)isThreeLogin {
    if (isThreeLogin) {
        
    } else {
        
        SH_AppDelegate.tokenMap.token = loginModel.tokenMap.token;
        SH_AppDelegate.tokenMap.userId = loginModel.tokenMap.userId;
        
        SH_AppDelegate.userData.afterSalesNum = loginModel.userData.afterSalesNum;
        SH_AppDelegate.userData.balance = loginModel.userData.balance;
        SH_AppDelegate.userData.couponNum = loginModel.userData.couponNum;
        SH_AppDelegate.userData.evaluationNum = loginModel.userData.evaluationNum;
        SH_AppDelegate.userData.fansNum = loginModel.userData.fansNum;
        SH_AppDelegate.userData.followNum = loginModel.userData.followNum;
        SH_AppDelegate.userData.initNum = loginModel.userData.initNum;
        SH_AppDelegate.userData.receiveNum = loginModel.userData.receiveNum;
        
        SH_AppDelegate.personInfo.userId = loginModel.tokenMap.userId;
        SH_AppDelegate.personInfo.avatar = loginModel.user.avatar;
        SH_AppDelegate.personInfo.mobile = loginModel.user.mobile;
        SH_AppDelegate.personInfo.nickName = loginModel.user.nickName;
        SH_AppDelegate.personInfo.introduce = loginModel.user.introduce;
        SH_AppDelegate.personInfo.sex = loginModel.user.sex;
        SH_AppDelegate.personInfo.birthday = loginModel.user.birthday;
        SH_AppDelegate.personInfo.password = loginModel.user.password;
        SH_AppDelegate.personInfo.realName = loginModel.user.realName;
        SH_AppDelegate.personInfo.city = loginModel.user.city;
        SH_AppDelegate.personInfo.longitude = loginModel.user.longitude;
        SH_AppDelegate.personInfo.latitude = loginModel.user.latitude;
        SH_AppDelegate.personInfo.isVerified = loginModel.user.isVerified;
        SH_AppDelegate.personInfo.volume = 1.0;
        
        [[EMClient sharedClient] loginWithUsername:loginModel.user.mobile password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
                
            }
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutHuanXin object:nil];

        
    }
}

//上传registerID，极光
- (void)uploadRegisterID
{
    NSString *registerId = SH_AppDelegate.personInfo.registerID ? SH_AppDelegate.personInfo.registerID : @"";
    NSDictionary *dic = @{
                          @"type":@"IOS",
                          @"registerId":registerId
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHRegisterIDUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
    } failure:^(NSError *error) {
        
    }];
    
    NSString *registId = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"] : @"";
    SHLog(@"%@", registId)
    NSDictionary *dict = @{
                           @"type":@"IOS",
                           @"registerId":registId
                           };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHRegisterIDUrl params:dict success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
    } failure:^(NSError *error) {
        
    }];
}


//验证码之前获取uuid
- (void)getUUID {
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SH_SecretAuthUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            NSDictionary *dict = nil;
            if (self.loginType == SHMessageLoginType) {
                dict = @{
                         @"mobile":_phoneTF.text,
                         @"type":@"2",
                         @"uuid":JSON[@"uuid"]
                         };
            } else if (self.loginType == SHBindPhoneType) {
                dict = @{
                         @"mobile":_phoneTF.text,
                         @"type":@"1",
                         @"uuid":JSON[@"uuid"]
                         };
            }
            
            [weakSelf getCodeFunctionWithDict:dict];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

//uuid获取短信验证码
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


//获取验证码之前判断手机号
- (BOOL)judgePhone:(NSString *)phone {
    if ([NSString isEmpty:phone]) {
        [MBProgressHUD showMBPAlertView:@"请输入手机号" withSecond:1.5];
        return NO;
    }
    if (![NSString isOKPhoneNumber:phone]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的手机号" withSecond:1.5];
        return NO;
    }
    
    return YES;
}

//登录确认之前判断手机号和验证码，密码
- (BOOL)judgePhoneAndCode {
    if ([NSString isEmpty:_phoneTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入手机号" withSecond:1.5];
        return NO;
    }
    if (![NSString isOKPhoneNumber:_phoneTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的手机号" withSecond:1.5];
        return NO;
    }
    //判断密码是否为空
    if ([NSString isEmpty:_codeTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入验证码" withSecond:1.5];
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
    } else if ([textField isEqual:_phoneTF]) {
        return textField.text.length < SHPhoneLength;
    }  else if ([textField isEqual:_codeTF]) {
        return textField.text.length < SHCodeLength;
    }
    return YES;
}

//触发相应
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if (textField == _phoneTF) {
        _phoneView.layer.borderColor = [SHColorFromHex(0x3d6b90) CGColor];
        _codeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    if (textField == _codeTF) {
        _codeView.layer.borderColor = [SHColorFromHex(0x3d6b90) CGColor];
        _phoneView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self allTFResignFirstResponder];
    return YES;
}

- (void)allTFResignFirstResponder {
    [_phoneTF resignFirstResponder];
    [_codeTF resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTFResignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
