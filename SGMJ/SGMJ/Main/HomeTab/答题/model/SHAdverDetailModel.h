//
//  SHAdverDetailModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHAnswerItemModel;

@interface SHAdverDetailModel : NSObject


@property (nonatomic, strong) NSArray *pics;
@property (nonatomic, assign) NSInteger adRadius;
@property (nonatomic, copy) NSString *introduce;//介绍
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, strong) NSArray <SHAnswerItemModel *>*problems;//问题
@property (nonatomic, copy) NSString *profit;//答题奖励
@property (nonatomic, assign) NSInteger surplusNum;//剩余
@property (nonatomic, assign) NSInteger deliveryNum;//广告剩余量




@end
