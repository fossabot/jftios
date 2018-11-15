//
//  AppDelegate+SHService.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "AppDelegate.h"


//友盟模块
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

//支付宝支付
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>


//极光
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


//苹果地图
#import <MapKit/MapKit.h>

//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate (SHService)

@end
