//
//  SHMoneyModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMoneyModel : NSObject


@property (nonatomic, assign) double balance;
@property (nonatomic, copy) NSString *bizType;              //类型
@property (nonatomic, copy) NSString *createTime;           //时间
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *trxType;              //join收入（+) expend消费(-)
@property (nonatomic, assign) double trxAmount;             //交易金额
@property (nonatomic, copy) NSString *Description;          //标题






@end
