//
//  SHWelfareModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/12.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHWelfareModel : NSObject


@property (nonatomic, assign) double authMoney;             //认证金额
@property (nonatomic, assign) double registeredMoney;       //注册金额
@property (nonatomic, assign) double shoppingMoney;         //交易金额
@property (nonatomic, assign) double signInMoney;           //注册金额
@property (nonatomic, assign) double skillMoney;            //技能认证金额

@property (nonatomic, assign) NSInteger isAuth;             //是否实名认证 0否 1是
@property (nonatomic, assign) NSInteger isRegistered;       //是否注册 0否 1是
@property (nonatomic, assign) NSInteger isSkill;            //是否发技能 0否 1是
@property (nonatomic, assign) NSInteger leftShareNum;       //剩余分享数量
@property (nonatomic, assign) NSInteger isShopping;         //是否消费 0否 1是
@property (nonatomic, assign) NSInteger isShare;            //成功分享数量
@property (nonatomic, assign) NSInteger isSignIn;           //今天是否签到


@end
