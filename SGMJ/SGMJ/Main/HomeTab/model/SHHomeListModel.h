//
//  SHHomeListModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/29.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHHomeListModel : NSObject

@property (nonatomic, assign) NSInteger allMoney;   //广告投放总金额
@property (nonatomic, assign) NSInteger click;      //广告点击量
@property (nonatomic, assign) NSInteger deliveryNum;//广告投放量
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) double lat;           //广告标题的公司地理纬度
@property (nonatomic, assign) double lng;           //广告标题的公司地理经度
@property (nonatomic, assign) NSInteger leftMoney;  //剩余总钱数
@property (nonatomic, copy) NSString *profit;     //每个答题奖励
@property (nonatomic, assign) NSInteger status;     //广告状态
@property (nonatomic, assign) NSInteger surplusNum; //广告剩余量
@property (nonatomic, copy) NSString *title;        //广告来源

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger createId;
@property (nonatomic, strong) NSMutableArray *pics;

@property (nonatomic, assign) double distance;




@end
