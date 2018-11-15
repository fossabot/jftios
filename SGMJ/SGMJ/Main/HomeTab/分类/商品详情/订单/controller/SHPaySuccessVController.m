//
//  SHPaySuccessVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPaySuccessVController.h"
#import "Home_ViewController.h"


@interface SHPaySuccessVController ()

@end

@implementation SHPaySuccessVController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //修改返回按钮
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //设置UIButton的图像
    [backButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    //覆盖返回按键
    self.navigationItem.leftBarButtonItem = backItem;

    
    
}

//返回
- (IBAction)backButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[Home_ViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//            
//        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

//完成
- (IBAction)completeButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[Home_ViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    //到订单页面
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
