//
//  SHSearchModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/9/18.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSearchModel : NSObject



@property (nonatomic, copy) NSString *content;                  //描述
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, assign) NSUInteger modelId;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *publishUserAvatar;
@property (nonatomic, assign) NSUInteger publishUserId;
@property (nonatomic, copy) NSString *publishUserNickName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *unit;





@end
