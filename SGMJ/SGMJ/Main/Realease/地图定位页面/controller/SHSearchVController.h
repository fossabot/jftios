//
//  SHSearchVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface SHSearchVController : ViewController


@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) void(^chooseAddress) (CLLocationCoordinate2D pt);



@end
