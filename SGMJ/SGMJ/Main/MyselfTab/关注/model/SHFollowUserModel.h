//
//  SHFollowUserModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHFollowUserModel : NSObject


@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, assign) NSInteger isVerified;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger ID;

@end
