//
//  SHOrderLisrChildViewController.h
//  SGMJ
//
//  Created by 曾建国 on 2018/8/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"


@interface SHOrderLisrChildViewController : ViewController

@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, assign) NSInteger isCustomer;


@property (nonatomic, assign) NSInteger isShelve;
@property (nonatomic, assign) SHNeedTingAndOrderType listType;

@property (nonatomic, copy) NSString *idString;

@property (nonatomic, copy) NSString *moneyType;

@end
