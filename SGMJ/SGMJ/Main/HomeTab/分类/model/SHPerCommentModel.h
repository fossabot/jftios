//
//  SHPerCommentModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHPerCommentModel : NSObject


@property (nonatomic, assign) NSInteger average;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, strong) NSDictionary *user;







@end
