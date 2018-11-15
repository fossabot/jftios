//
//  SHReportPriceModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/13.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHReportPriceModel : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger creditRating;

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger needId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger timePeriod;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double price;

@property (nonatomic, assign) CGFloat cellHeight;

@end
