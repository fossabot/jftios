//
//  SHLocationManager.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHLocationManager.h"

@implementation SHLocationManager


+ (SHLocationManager *)shareInstance
{
    static SHLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SHLocationManager alloc] init];
        manager.locationManager = [[CLLocationManager alloc] init];
        //manager.locationManager.delegate = self;
        
        //设置设备是否可暂停定位来节省电池的电量，
        /*
         * 如果该属性设为YES，则当iOS设备不再需要定位数据时，iOS设备可自动暂停定位
         * 如果不设置为NO，只能在后台运行15分钟后就会处于挂起状态。
         */
        manager.locationManager.pausesLocationUpdatesAutomatically = NO;
        //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
        if ([manager.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
            // 若不设置，默认为NO。不会后台进行定位。
            if (@available(iOS 9.0, *)) {
                //[manager.locationManager setAllowsBackgroundLocationUpdates:YES];
            } else {
                // Fallback on earlier versions
            }
        }
        
    });
    return manager;
}

//开始定位
- (void)startLocation
{
    [self.locationManager startUpdatingLocation];
}

//结束定位
- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}






@end
