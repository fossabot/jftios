//
//  SHMyOrderDetailModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMyOrderDetailModel : NSObject


@property (nonatomic, strong) NSDictionary *arrive;
@property (nonatomic, strong) NSDictionary *depart;
@property (nonatomic, strong) NSDictionary *goodsData;
@property (nonatomic, assign) NSUInteger isCustomer;
@property (nonatomic, copy) NSString *orderContent;
@property (nonatomic, copy) NSString *orderCreateTime;
@property (nonatomic, assign) NSUInteger orderId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *orderProductType;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, strong) NSDictionary *userData;







@end
