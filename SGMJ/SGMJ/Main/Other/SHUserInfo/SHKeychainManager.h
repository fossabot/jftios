//
//  SHKeychainManager.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/18.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHKeychainManager : NSObject




+ (SHKeychainManager *)default;

//根据字典存储对象到钥匙串
- (void)save:(NSString *)service data:(id)data;

//根据字典读取钥匙串里的对象
- (id)load:(NSString *)service;

- (void)delete:(NSString *)service;


@end
