//
//  SHModifyPsdVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHModifyPsdVController.h"

@interface SHModifyPsdVController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPsdTF;

@property (weak, nonatomic) IBOutlet UITextField *nPsdTF;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *oldView;
@property (weak, nonatomic) IBOutlet UIView *nView;

@end

@implementation SHModifyPsdVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"修改登录密码";
    
    _oldView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _oldView.layer.cornerRadius = _oldView.height / 2;
    _oldView.clipsToBounds = YES;
    _oldView.layer.borderWidth = 1;
    _oldView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _nView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _nView.layer.cornerRadius = _nView.height / 2;
    _nView.clipsToBounds = YES;
    _nView.layer.borderWidth = 1;
    _nView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [_sureButton setBackgroundColor:navColor];
    _sureButton.layer.cornerRadius = _sureButton.height / 2;
    _sureButton.clipsToBounds = YES;
    
}


- (IBAction)sureButtonClick:(UIButton *)sender {
    if ([self judgeTextFieldNeed]) {
        SHWeakSelf
        NSDictionary *dic = @{
                              @"oldPassword":_oldPsdTF.text,
                              @"newPassword":_nPsdTF.text
                              };
        SHLog(@"%@", dic)
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHModifyLoginPsdUrl params:dic success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", msg)
            if (code == 0) {
                [MBProgressHUD showMBPAlertView:@"登录密码设置成功,请重新登录" withSecond:2.0];
                [SH_AppDelegate userLogout];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SHLogoutSuccess" object:nil];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

- (BOOL)judgeTextFieldNeed
{
    
    if ([NSString isEmpty:_oldPsdTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入旧密码" withSecond:2.0];
        return NO;
    }
    if ([NSString isEmpty:_nPsdTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入新密码" withSecond:2.0];
        return NO;
    }
    if ([_oldPsdTF.text isEqualToString:_nPsdTF.text]) {
        [MBProgressHUD showMBPAlertView:@"两次输入的密码一致" withSecond:2.0];
        return NO;
    }
    return YES;
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
