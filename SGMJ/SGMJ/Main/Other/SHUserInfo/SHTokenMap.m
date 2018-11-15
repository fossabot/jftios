//
//  SHTokenMap.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHTokenMap.h"

@implementation SHTokenMap

+ (instancetype)sharedTokenMap
{
    static SHTokenMap *tokenMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tokenMap = [[SHTokenMap alloc] init];
    });
    return tokenMap;
}

- (id)init
{
    self = [super init];
    if (self) {
        _token = [SH_UserDefaults objectForKey:SH_TOKEN];
        _userId = [SH_UserDefaults integerForKey:Key_userId];
    }
    return self;
}

- (void)setToken:(NSString *)token
{
    _token = token;
    [SH_UserDefaults setObject:token forKey:SH_TOKEN];
}

- (void)setUserId:(NSInteger)userId
{
    _userId = userId;
    [SH_UserDefaults setInteger:userId forKey:Key_userId];
}

- (void)setCacheTime:(NSInteger)cacheTime
{
    _cacheTime = cacheTime;
    [SH_UserDefaults setInteger:cacheTime forKey:Key_cacheTime];
}


- (void)cleanToken
{
    SH_AppDelegate.tokenMap.userId = 0;
    SH_AppDelegate.tokenMap.token = nil;
    SH_AppDelegate.tokenMap.cacheTime = 0;
    
    [SH_UserDefaults removeObjectForKey:SH_TOKEN];
    [SH_UserDefaults removeObjectForKey:Key_userId];
    [SH_UserDefaults removeObjectForKey:Key_cacheTime];
}










@end
