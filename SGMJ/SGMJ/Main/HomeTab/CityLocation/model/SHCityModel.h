//
//  SHCityModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHCityModel : NSObject


@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *spell;
@property (nonatomic, strong) NSString *firstLetter;

@property (nonatomic, strong) NSMutableArray *childrens;


- (instancetype)initWithCityDict:(NSDictionary *)dic;
+ (instancetype)cityWithDict:(NSDictionary *)dic;


@end
