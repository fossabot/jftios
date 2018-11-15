//
//  SH_PayUtil.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SH_PayModel.h"
#import "SHOrderModel.h"

typedef enum : NSUInteger {
    kSH_PayUtilTypeWXPay = 0,       //微信支付
    kSH_PayUtilTypeAlipay = 1,       //支付宝支付
    kSH_PayUtilTypeApplePay = 2,      //苹果支付
    kSH_PayUtilTypeYue = 3, //余额支付方式
}SH_PayUtilType;

@interface SH_PayUtil : NSObject


+ (SH_PayUtil *)sharedInstance;

//去支付
/**
 *  @param money 微信的单位为分    支付宝的单位为元
 */
- (void)gotoPay:(SH_PayUtilType)payUtilType withPayMoney:(double)money withOrder:(SHOrderModel *)orderModel;


@end
