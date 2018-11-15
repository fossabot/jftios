//
//  CitySelectedViewController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"

@class SHCityModel;

@interface CitySelectedViewController : ViewController

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) void (^cityPickerBlock)(SHCityModel *city);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
