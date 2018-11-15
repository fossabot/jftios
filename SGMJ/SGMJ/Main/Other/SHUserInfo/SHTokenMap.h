//
//  SHTokenMap.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/3.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHTokenMap : NSObject


+ (instancetype)sharedTokenMap;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger cacheTime;

- (void)cleanToken;


@end
