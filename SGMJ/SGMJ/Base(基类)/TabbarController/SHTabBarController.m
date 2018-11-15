//
//  SHTabBarController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHTabBarController.h"
#import "SH_NavgationViewController.h"
#import "Home_ViewController.h"
#import "Message_ViewController.h"

#import "SHListViewController.h"

#import "RealeaseViewController.h"
#import "Order_ViewController.h"
#import "Myself_ViewController.h"
#import "SHTabBar.h"
#import "ChatDemoHelper.h"
#import "SHLoginViewController.h"

@interface SHTabBarController () <SHTabBarDelegate>

@end

@implementation SHTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearance];


    NSDictionary *dictNormal = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName : [UIFont systemFontOfSize:12]};

    NSDictionary *dictSelected = @{NSForegroundColorAttributeName : SHColorFromHex(0x00a9f0),NSFontAttributeName : [UIFont systemFontOfSize:12]};

    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildVC];
    
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    SHTabBar *tabBar = [[SHTabBar alloc] init];
    tabBar.myDelegate = self;
    //kvc实质是修改系统的_tabBar
    [self setValue:tabBar forKey:@"tabBar"];
    
    //解决音视频通话返回到maintabbar，背景变色问题
    self.tabBar.tintColor = [UIColor colorWithRed:89/255.0 green:217/255.0 blue:247/255.0 alpha:1.0];
    [self.tabBar setTranslucent:NO];
    
    //未读消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self setupUnreadMessageCount];
    
}

#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮
- (void)setUpAllChildVC
{
    Home_ViewController *homeVC = [[Home_ViewController alloc] init];
    [self setUpOneChildVCWithVc:homeVC image:@"tabbar_home_normal" selectedImage:@"tabbar_home_selected" title:@"首页"];
    
//    Message_ViewController *msgVC = [[Message_ViewController alloc] init];
    _msgVC = [[SHListViewController alloc] init];
    [self setUpOneChildVCWithVc:_msgVC image:@"tabbar_message_normal" selectedImage:@"tabbar_message_selected" title:@"消息"];
    
    Order_ViewController *orderVC = [[Order_ViewController alloc] init];
    [self setUpOneChildVCWithVc:orderVC image:@"tabbar_lobby_normal" selectedImage:@"tabbar_lobby_selected" title:@"大厅"];
    
    Myself_ViewController *myVC = [[Myself_ViewController alloc] init];
    [self setUpOneChildVCWithVc:myVC image:@"tabbar_mine_normal" selectedImage:@"tabbar_mine_selected" title:@"我的"];
    
    
    
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法
/**
 *  设置单个tabBarButton
 *  @param  vc              每一个按钮对应的控制器
 *  @param  image           每一个按钮对应的普通状态下的图片
 *  @param  selectedImage   每一个按钮对应的选中状态下的图片
 *  @param  title           每一个按钮对应的标题
 */
- (void)setUpOneChildVCWithVc:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    SH_NavgationViewController *nav = [[SH_NavgationViewController alloc] initWithRootViewController:vc];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，系统提供模型，专门负责tababr上按钮的文字以及图片展示
    vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = mySelectedImage;
    
    vc.tabBarItem.title = title;
    vc.navigationItem.title = title;
    [self addChildViewController:nav];
    
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self setupUnreadMessageCount];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    
    //统计未读消息个数
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    SHLog(@"未读消息的个数：%i", (int)unreadCount)
    if (_msgVC) {
        if (unreadCount > 0) {
            _msgVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        } else {
            _msgVC.tabBarItem.badgeValue = nil;
        }
    }
    
   
    
}

#pragma mark - SHTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(SHTabBar *)tabBar
{
    
    if (!SH_AppDelegate.personInfo.isLogin) {
        
        SHLoginViewController *loginVc = [[SHLoginViewController alloc] init];
        SH_NavgationViewController *nav = [[SH_NavgationViewController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    RealeaseViewController *plusVC = [[RealeaseViewController alloc] init];
    SH_NavgationViewController *nav = [[SH_NavgationViewController alloc] initWithRootViewController:plusVC];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    SHLog(@"%@", item.title)
    
    if ([item.title isEqualToString:@"消息"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutHuanXin object:nil];
    } else if ([item.title isEqualToString:@"大厅"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
    } else if ([item.title isEqualToString:@"我的"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMineRefresh object:nil];
    } else if ([item.title isEqualToString:@"首页"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"answerCorrect" object:nil];
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
    
    //[self setupUnreadMessageCount];
    [self animationWithIndex:index];
}

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
}




- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
}





@end
