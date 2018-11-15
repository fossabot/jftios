//
//  SH_NavgationViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_NavgationViewController.h"

@interface SH_NavgationViewController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>
//<UIGestureRecognizerDelegate>

//@property (nonatomic, strong) id popDelegate;


@end

@implementation SH_NavgationViewController

//每次运行，只执行一次
+ (void)initialize
{
    [[UINavigationBar appearance] setBarTintColor:SH_WhiteColor];
//    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: SH_TitleColor}];
//    [[UINavigationBar appearance] setBackgroundColor:navColor];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = SH_TitleColor;
    
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //  这句很核心 稍后讲解
//    id target = self.interactivePopGestureRecognizer.delegate;
//    //  这句很核心 稍后讲解
//    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
//    //  获取添加系统边缘触发手势的View
//    UIView *targetView = self.interactivePopGestureRecognizer.view;
//
//    //  创建pan手势 作用范围是全屏
//    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
//    fullScreenGes.delegate = self;
//    [targetView addGestureRecognizer:fullScreenGes];
//
//    // 关闭边缘触发手势 防止和原有边缘手势冲突
//    [self.interactivePopGestureRecognizer setEnabled:NO];
    
    
    
}


- (UIImage *)imageWithOriImageName:(NSString *)imageName
{
    //传入一张图片,返回一张不被渲染的图片
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - 实现代理方法

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self imageWithOriImageName:@"return"] style:0 target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

#pragma mark - 滑动开始触发事件
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    

    return self.childViewControllers.count == 1 ? NO : YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
