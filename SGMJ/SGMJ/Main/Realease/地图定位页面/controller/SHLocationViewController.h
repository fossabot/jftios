//
//  SHLocationViewController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SHSelectedAddressBlock)(NSString *address,NSString *name,CLLocationCoordinate2D pt, NSString *city);


@interface SHLocationViewController : ViewController



@property (nonatomic, copy) SHSelectedAddressBlock addressBlock;



@end
