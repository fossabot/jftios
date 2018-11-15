//
//  SH_PayAlipayModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_PayAlipayModel : NSObject




@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *outTradeNo;
@property (nonatomic, copy) NSString *notifyUrl;
@property (nonatomic, copy) NSString *Description;  //body
@property (nonatomic, copy) NSString *title;    //subject

@end
