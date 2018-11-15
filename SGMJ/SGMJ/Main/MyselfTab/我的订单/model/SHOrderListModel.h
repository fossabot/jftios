//
//  SHOrderListModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/1.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHOrderListModel : NSObject


@property (nonatomic, assign) NSUInteger amount;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, assign) NSUInteger orderId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *orderProductType;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *realPrice;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *univalence;
@property (nonatomic, strong) NSDictionary *userData;

@property (nonatomic, assign) NSUInteger isCustomer;







@end
