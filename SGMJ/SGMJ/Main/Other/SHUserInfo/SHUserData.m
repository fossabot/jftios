//
//  SHUserData.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHUserData.h"

@implementation SHUserData

+ (instancetype)sharedUserData
{
    static SHUserData *userData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[SHUserData alloc] init];
    });
    return userData;
}

- (id)init
{
    self = [super init];
    if (self) {
        _afterSalesNum = [SH_UserDefaults integerForKey:Key_afterSalesNum];
        _balance = [SH_UserDefaults doubleForKey:Key_balance];
        _couponNum = [SH_UserDefaults integerForKey:Key_couponNum];
        _evaluationNum = [SH_UserDefaults integerForKey:Key_evaluationNum];
        _fansNum = [SH_UserDefaults integerForKey:Key_fansNum];
        _followNum = [SH_UserDefaults integerForKey:Key_followNum];
        _receiveNum = [SH_UserDefaults integerForKey:Key_receiveNum];
    }
    return self;
}



- (void)setAfterSalesNum:(NSInteger)afterSalesNum
{
    _afterSalesNum = afterSalesNum;
    [SH_UserDefaults setInteger:afterSalesNum forKey:Key_afterSalesNum];
}

- (void)setBalance:(double)balance
{
    _balance = balance;
    [SH_UserDefaults setDouble:balance forKey:Key_balance];
}

- (void)setCouponNum:(NSInteger)couponNum
{
    _couponNum = couponNum;
    [SH_UserDefaults setInteger:couponNum forKey:Key_couponNum];
}

- (void)setEvaluationNum:(NSInteger)evaluationNum
{
    _evaluationNum = evaluationNum;
    [SH_UserDefaults setInteger:evaluationNum forKey:Key_evaluationNum];
}

- (void)setFansNum:(NSInteger)fansNum
{
    _fansNum = fansNum;
    [SH_UserDefaults setInteger:fansNum forKey:Key_fansNum];
}

- (void)setFollowNum:(NSInteger)followNum
{
    _followNum = followNum;
    [SH_UserDefaults setInteger:followNum forKey:Key_followNum];
}

- (void)setInitNum:(NSInteger)initNum
{
    _initNum = initNum;
    [SH_UserDefaults setInteger:initNum forKey:Key_initNum];
}

- (void)setReceiveNum:(NSInteger)receiveNum
{
    _receiveNum = receiveNum;
    [SH_UserDefaults setInteger:receiveNum forKey:Key_receiveNum];
}

- (void)cleanUserData
{
    SH_AppDelegate.userData.afterSalesNum = 0;
    SH_AppDelegate.userData.balance = 0;
    SH_AppDelegate.userData.couponNum = 0;
    SH_AppDelegate.userData.evaluationNum = 0;
    SH_AppDelegate.userData.fansNum = 0;
    SH_AppDelegate.userData.followNum = 0;
    SH_AppDelegate.userData.initNum = 0;
    SH_AppDelegate.userData.receiveNum = 0;
    
    [SH_UserDefaults removeObjectForKey:Key_afterSalesNum];
    [SH_UserDefaults removeObjectForKey:Key_balance];
    [SH_UserDefaults removeObjectForKey:Key_couponNum];
    [SH_UserDefaults removeObjectForKey:Key_evaluationNum];
    [SH_UserDefaults removeObjectForKey:Key_fansNum];
    [SH_UserDefaults removeObjectForKey:Key_followNum];
    [SH_UserDefaults removeObjectForKey:Key_initNum];
    [SH_UserDefaults removeObjectForKey:Key_receiveNum];
}



@end
