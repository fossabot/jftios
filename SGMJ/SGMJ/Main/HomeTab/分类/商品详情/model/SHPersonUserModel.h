//
//  SHPersonUserModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHPersonUserModel : NSObject


@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *createTime;


@end
