//
//  SHPersonalViewController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"


@class SHCatagoryListModel;
@interface SHPersonalViewController : ViewController


@property (nonatomic, strong) SHCatagoryListModel *model;

@property (nonatomic, assign) NSInteger providerId;

@end
