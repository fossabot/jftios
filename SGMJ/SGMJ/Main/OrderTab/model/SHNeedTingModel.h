//
//  SHNeedTingModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHNeedTingModel : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) double distance;

@property (nonatomic, assign) NSInteger isFollowed;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, assign) NSInteger leftDays;
@property (nonatomic, assign) double money;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *needUserAvatar;
@property (nonatomic, copy) NSString *needUserMobile;
@property (nonatomic, assign) NSInteger needUserId;
@property (nonatomic, assign) NSInteger needId;
@property (nonatomic, copy) NSString *needUserNickName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *title;


/** cell的高度 */
@property (assign, nonatomic) CGFloat cellHeight;

- (SHNeedTingModel *)calculateHeight:(SHNeedTingModel *)model;

@end
