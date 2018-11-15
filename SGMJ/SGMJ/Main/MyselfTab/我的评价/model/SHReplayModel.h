//
//  SHReplayModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHReplayModel : NSObject

@property (nonatomic, assign) NSUInteger assessId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSUInteger isCustomer;        //1.服务者回复：。。。0.客户回复:。。。
@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) NSUInteger ID;


@end
