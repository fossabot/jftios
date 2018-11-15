//
//  SHLoginViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHLoginViewController.h"

#import "SHMessageLoginVController.h"
#import "SHFindPsdVController.h"

#import "SHLoginModel.h"
#import "SHPersonInfo.h"
//#import <UMSocialCore/UMSocialCore.h>
#import <UMShare/UMShare.h>
#import "SHTabBarController.h"


@interface SHLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *psdView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *psdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *lineLabelTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconMarginTopContraint;



@end

@implementation SHLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self allTFResignFirstResponder];
}

// 获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        SHLog(@"%@%d: %@", blank, level, subview.class);
        [self getSub:subview andLevel:(level+1)];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    
    
    
}

#pragma mark - privateFunction
- (void)initBaseInfo {
    
    _lineLabelOne.backgroundColor = SH_RGBA(108, 115, 124, 1);
    _lineLabelTwo.backgroundColor = SH_RGBA(108, 115, 124, 1);
    
    _loginView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    _phoneView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    _psdView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    [_phoneTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTF setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [_psdTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_psdTF setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _psdTF.secureTextEntry = YES;
    
    _loginButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerButtonClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (SH_IPHONE_X) {
        _marginTopContraint.constant = StatusBar_height + 36;
        _iconMarginTopContraint.constant = StatusBar_height + 80;
    } else {
        _marginTopContraint.constant = 36;
        _iconMarginTopContraint.constant = 80;
    }
    
}

#pragma mark - buttonFunction
//注册action
- (void)registerButtonClick {
    
    SHFindPsdVController *vc = [[SHFindPsdVController alloc] init];
    vc.loginType = SHRegisterStatus;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)registerBtnClick:(id)sender {
    SHFindPsdVController *vc = [[SHFindPsdVController alloc] init];
    vc.loginType = SHRegisterStatus;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//登录action
- (IBAction)loginButtonClick:(UIButton *)sender {
    SHWeakSelf
    if (sender.tag == 10) {
        if ([self judgePhoneAndPsd]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *city = SH_AppDelegate.personInfo.city ? SH_AppDelegate.personInfo.city : @"";
            NSDictionary *dic = @{
                                  @"mobile":_phoneTF.text,
                                  @"city":city,
                                  @"loginType":@"pass",
                                  @"password":_psdTF.text,
                                  @"lon":@(SH_AppDelegate.personInfo.longitude),
                                  @"lat":@(SH_AppDelegate.personInfo.latitude)
                                  };
            SHLog(@"%@", dic)
            [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHLoginUrl params:dic success:^(id JSON, int code, NSString *msg) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                if (code == 0) {
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
                } else {
                    [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
                }

            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }];
        }
    }
    else if (sender.tag == 11) {
        [self getThirdLoginWithType:UMSocialPlatformType_QQ];
    } else if (sender.tag == 12) {
        [self getThirdLoginWithType:UMSocialPlatformType_WechatSession];
    } else if (sender.tag == 13) {
        SHLog(@"WB")
    }
    
}

/**
 *  三方登录
 */
- (void)getThirdLoginWithType:(UMSocialPlatformType)loginType {
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:loginType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"登录失败"];
        } else {
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                UMSocialUserInfoResponse *umresponse = result;
                NSString *type = nil;
                NSDictionary *dic = nil;
                if (loginType == UMSocialPlatformType_QQ) {
                    type = @"QQ";
                    dic = @{
                            @"type":type,
                            @"key":umresponse.openid,
                            @"avatar":umresponse.iconurl,
                            @"nickName":umresponse.name
                            };
                } else if (loginType == UMSocialPlatformType_WechatSession) {
                    type = @"WEIXIN";
                    dic = @{
                            @"type":type,
                            @"key":umresponse.unionId,
                            @"avatar":umresponse.iconurl,
                            @"nickName":umresponse.name
                            };
                } else if (loginType == UMSocialPlatformType_Sina) {
                    type = @"SINA";
                }
                
                [weakSelf thirdLoginWithDictionary:dic];
                
            }
        }

    }];
    
    
}

/**
 *  三方登录
 */
- (void)thirdLoginWithDictionary:(NSDictionary *)dic
{
    //SHLog(@"%@", dic)
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHThirdLoginUrl params:dic success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        //SHLog(@"%@", msg)
        //SHLog(@"%@", JSON)
        if (code == 100) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            
            
            
            //绑定手机号
            NSDictionary *dic = JSON;
            SHMessageLoginVController *vc = [[SHMessageLoginVController alloc] init];
            vc.loginType = SHBindPhoneType;
            vc.dic = dic;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (code == 0) {
            //第一次三方登录之后登陆直接返回个人信息登陆
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
            
            [MBProgressHUD showMBPAlertView:@"登录成功" withSecond:2.0];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
            
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

//短信快捷登录
- (IBAction)messageButtonClick:(UIButton *)sender {
    
    SHMessageLoginVController *vc = [[SHMessageLoginVController alloc] init];
    vc.loginType = SHMessageLoginType;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//找回密码
- (IBAction)findPsdButtonClick:(UIButton *)sender {
    
    SHFindPsdVController *vc = [[SHFindPsdVController alloc] init];
    vc.loginType = SHFindPsdStatus;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)judgePhoneAndPsd {
    if ([NSString isEmpty:_phoneTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入手机号" withSecond:2.0];
        return NO;
    }
    if (![NSString isOKPhoneNumber:_phoneTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的手机号" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_psdTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入密码" withSecond:2.0];
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
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self allTFResignFirstResponder];
    return YES;
}

- (void)allTFResignFirstResponder {
    [_phoneTF resignFirstResponder];
    [_psdTF resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTFResignFirstResponder];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
