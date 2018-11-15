//
//  SHMessageModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMessageModel : NSObject


@property (nonatomic, copy) NSString *content;              //描述
@property (nonatomic, copy) NSString *createTime;           //时间
@property (nonatomic, assign) NSInteger faceUser;           //
@property (nonatomic, assign) NSInteger ID;                 //
@property (nonatomic, copy) NSString *key;                  //次类型
@property (nonatomic, copy) NSString *model;              //主类型
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *value;




@end



