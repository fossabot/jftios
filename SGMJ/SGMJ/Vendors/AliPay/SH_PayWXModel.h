//
//  SH_PayWXModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_PayWXModel : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *timestamp;



@end
