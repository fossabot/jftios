//
//  SHEvaluateDetailModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHReplayModel;
@interface SHEvaluateDetailModel : NSObject


@property (nonatomic, assign) NSUInteger assessId;
@property (nonatomic, copy) NSString *assessUserAvatar;
@property (nonatomic, assign) NSUInteger assessUserId;
@property (nonatomic, copy) NSString *assessUserNickName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *productImg;
@property (nonatomic, assign) double productPrice;
@property (nonatomic, copy) NSString *productTitle;
@property (nonatomic, copy) NSString *productUnit;
@property (nonatomic, strong) NSArray *replyList;
@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, copy) NSString *targetUserAvatar;
@property (nonatomic, assign) NSUInteger targetUserId;
@property (nonatomic, copy) NSString *targetUserNickName;



@end
