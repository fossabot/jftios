//
//  SHTokenManager.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHTokenManager.h"

NSString *const TOKEN_KEY = @"token";

@implementation SHTokenManager

//存储
+ (void)saveToken:(NSString *)token
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *tokenData = [NSKeyedArchiver archivedDataWithRootObject:token];
    [userDefaults setValue:tokenData forKey:TOKEN_KEY];
    [userDefaults synchronize];
    
}

//读取
+ (NSString *)getToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *tokenData = [userDefaults objectForKey:TOKEN_KEY];
    NSString *token = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
    [userDefaults synchronize];
    return token;
}

//清空
+ (void)cleanToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:TOKEN_KEY];
    [userDefaults synchronize];
}


//更新
+ (NSString *)refreshToken
{
    return nil;
}


















@end
