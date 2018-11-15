//
//  AppDelegate.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/15.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPersonInfo.h"
#import "SHTokenMap.h"
#import "SHUserData.h"


@class SHTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//@property (nonatomic, strong) SHTabBarController *tabbarController;

/**
 判断用户时候已经登录
 **/
@property (nonatomic, assign) BOOL isPersonLogin;
/**
 *  
 */
@property (nonatomic, strong) SHPersonInfo *personInfo;


/**
 *
 */
@property (nonatomic, strong) SHTokenMap *tokenMap;

/**
 *
 */
@property (nonatomic, strong) SHUserData *userData;


- (void)userLogout;

- (void)userLogin;

/**
 *  判断是否开启定位功能
 */
+ (BOOL)isLocationServiceOpen;

/**
 *  上传经纬度
 */
- (void)openLocationTimer;

/**
 *  关闭上传经纬度
 */
- (void)closeLocationTimer;

@end

