//
//  SHUserData.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUserData : NSObject


+ (instancetype)sharedUserData;

@property (nonatomic, assign) NSInteger afterSalesNum;          //售后中
@property (nonatomic, assign) double balance;                //账户余额
@property (nonatomic, assign) NSInteger couponNum;              //优惠券数量
@property (nonatomic, assign) NSInteger evaluationNum;          //待评价
@property (nonatomic, assign) NSInteger fansNum;                //粉丝数量
@property (nonatomic, assign) NSInteger followNum;              //关注数量
@property (nonatomic, assign) NSInteger initNum;                //待付款
@property (nonatomic, assign) NSInteger receiveNum;             //待收货



- (void)cleanUserData;



@end
