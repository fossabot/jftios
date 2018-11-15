//
//  SH_PaySuccessModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_PaySuccessModel : NSObject

@property (nonatomic, assign) double bankAmount;
@property (nonatomic, assign) double balance;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *out_trade_no;
@property (nonatomic, assign) int orderId;


@end
