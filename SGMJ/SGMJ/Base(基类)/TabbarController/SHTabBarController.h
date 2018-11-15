//
//  SHTabBarController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHListViewController;
@interface SHTabBarController : UITabBarController


@property (nonatomic, strong) SHListViewController *msgVC;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)setupUnreadMessageCount;
@end
