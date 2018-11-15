//
//  SHLoginModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHPersonInfo;
@class SHTokenMap;
@class SHUserData;


@interface SHLoginModel : NSObject

@property (nonatomic, assign) NSInteger isLogin;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) SHPersonInfo *user;
@property (nonatomic, strong) SHTokenMap *tokenMap;
@property (nonatomic, strong) SHUserData *userData;
@property (nonatomic, assign) NSInteger isRedCash;
@property (nonatomic, copy) NSString *money;

@end
