//
//  SHServiceCommentModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHPersonUserModel;
@interface SHServiceCommentModel : NSObject



@property (nonatomic, assign) NSUInteger average;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) SHPersonUserModel *user;






@end
