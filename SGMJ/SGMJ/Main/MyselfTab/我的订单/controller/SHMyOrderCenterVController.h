//
//  SHMyOrderCenterVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"


typedef NS_ENUM(NSUInteger, SHBuyAndSell) {
    SHBuyGoodsType          =   0,              //买入
    SHSellGoodsType                             //卖出
};



@interface SHMyOrderCenterVController : ViewController


@property (nonatomic, assign) SHAllOrderStatusType orderType;



@end
