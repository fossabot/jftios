//
//  SHTokenManager.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHTokenManager : NSObject

//存储token
+ (void)saveToken:(NSString *)token;


//读取token
+ (NSString *)getToken;


//清空token
+ (void)cleanToken;

//更新token
+ (NSString *)refreshToken;

@end
