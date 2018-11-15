//
//  RealeaseViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "RealeaseViewController.h"
#import "ViewController.h"
#import "SHRServiceViewController.h"
#import "SHRFindServiceVController.h"
#import "SHRReleaseViewController.h"
#import "SHRAdverViewController.h"
#import "SHVerifyIDViewController.h"
#import "SH_NavgationViewController.h"
#import "SHTabBarController.h"

#import "SHLoginViewController.h"

#import "SH_TwoViewController.h"
#import "SHRelCataModel.h"
@interface RealeaseViewController ()


@property (nonatomic, strong) NSMutableDictionary *dic;


@end

@implementation RealeaseViewController

/**
 *  隐藏导航栏
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self checkIsOrNotAuthorised];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SHLog(@"%ld", (long)SH_AppDelegate.personInfo.isVerified)
          
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"catagory" object:nil];
    
    _dic = [NSMutableDictionary dictionary];
    [self loadCatagory];
}

- (void)loadCatagory
{
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaServCatUrl params:nil success:^(id JSON, int code, NSString *msg) {
        //        SHLog(@"%d", code)
        //SHLog(@"%@", JSON)
        if (code == 0) {
            NSArray *array = [SHRelCataModel mj_objectArrayWithKeyValuesArray:JSON[@"categories"]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            _dic = dic;
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}




/**
 *  监测用户的实名认证进展
 */
- (void)checkIsOrNotAuthorised
{
    if (SH_AppDelegate.isPersonLogin) {
        //登录    -- 监测是否实名认证
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCheckAuthoriseUrl params:nil success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", JSON)
            if (code == 0) {
                NSInteger status = [JSON[@"status"] integerValue];
                SH_AppDelegate.personInfo.isVerified = status;
            }
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        //未登录
        
    }
    
}


/**
 *  需求秘籍
 */
- (IBAction)releaseSceretButtonClick:(UIButton *)sender {
    SHRServiceViewController *vc = [[SHRServiceViewController alloc] init];
    vc.type = SHRequiredType;;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  查找服务秘籍
 */
- (IBAction)checkServiceButtonClick:(UIButton *)sender {
    
    SHRServiceViewController *vc = [[SHRServiceViewController alloc] init];
    vc.type = SHServiceType;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  一键发布广告
 */
- (IBAction)releaseAdvertiseBtnClick:(UIButton *)sender {
    
    SHRAdverViewController *vc = [[SHRAdverViewController alloc] init];
    [self pushVc:vc];
    
}

/**
 *  一键发布需求
 */
- (IBAction)findServiceButtonClick:(UIButton *)sender {
    
    SHRFindServiceVController *vc = [[SHRFindServiceVController alloc] init];
    [self pushVc:vc];
    
}

/**
 *  发布技能服务
 */
- (IBAction)releaseRequirementBtnClick:(UIButton *)sender {
    //0.默认，1.申请中的状态，2.成功，3.失败
    SHWeakSelf
    if (SH_AppDelegate.isPersonLogin) {
        if (SH_AppDelegate.personInfo.isVerified == 0) {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您需要认证审核，才能发布技能!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *act2=[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
                
                [weakSelf pushVc:vc];
            }];
            [controller addAction:act1];
            [controller addAction:act2];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        } else if (SH_AppDelegate.personInfo.isVerified == 1) {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您的身份认证正在审核中，审核通过之后才能发布技能!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [controller addAction:act1];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        } else if (SH_AppDelegate.personInfo.isVerified == 2) {//成功
            SHRReleaseViewController *vc = [[SHRReleaseViewController alloc] init];
            [self pushVc:vc];
        } else if (SH_AppDelegate.personInfo.isVerified == 3) {//失败
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的用户您好，您的实名认证失败，请重新认证!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *act2=[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
                
//                [weakSelf.navigationController pushViewController:vc animated:YES];
                [weakSelf pushVc:vc];
                
            }];
            [controller addAction:act1];
            [controller addAction:act2];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        }
    } else {
        //未登录-->登录页面
//        [SH_AppDelegate userLogin];
        SHLoginViewController *vc = [SHLoginViewController alloc];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:nav animated:YES completion:nil];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    
    
}

/**
 *  关闭页面
 */
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




/**
 push到二级界面

 @param vc 二级控制器
 */
- (void)pushVc:(UIViewController *)vc {
    
    
    
    SHTabBarController *tabbarVc = (SHTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    SH_NavgationViewController *nav = (SH_NavgationViewController *)tabbarVc.selectedViewController;
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        [nav pushViewController:vc animated:YES];
    }];
    
}













@end
