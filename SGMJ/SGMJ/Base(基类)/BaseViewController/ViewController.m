//
//  ViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/15.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden=YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden=NO;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //以下两行代码根据需要设置
    self.edgesForExtendedLayout = YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
}






@end
