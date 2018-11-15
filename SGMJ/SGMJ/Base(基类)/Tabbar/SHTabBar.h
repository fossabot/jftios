//
//  SHTabBar.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHTabBar;

@protocol SHTabBarDelegate <NSObject>

@optional
- (void)tabBarPlusBtnClick:(SHTabBar *)tabBar;
@end

@interface SHTabBar : UITabBar


/**
 *  tabbar的代理
 */
@property (nonatomic, weak) id <SHTabBarDelegate> myDelegate;



- (void)showBadgeOnItemIndex:(NSInteger)index;

- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
