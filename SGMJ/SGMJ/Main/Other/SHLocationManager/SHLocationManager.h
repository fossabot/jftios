//
//  SHLocationManager.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SHLocationManager : NSObject


@property (nonatomic, strong) CLLocationManager *locationManager;


+ (SHLocationManager *)shareInstance;

- (void)startLocation;

- (void)stopLocation;

@end
