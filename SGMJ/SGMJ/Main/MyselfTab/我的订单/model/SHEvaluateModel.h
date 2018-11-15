//
//  SHEvaluateModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHEvaluateModel : NSObject

@property (nonatomic, copy) NSString *content;          //评论
@property (nonatomic, strong) NSArray *images;          //图片
@property (nonatomic, assign) NSUInteger mannerScore;   //态度
@property (nonatomic, assign) NSUInteger serveScore;    //服务
@property (nonatomic, assign) NSUInteger speedScore;    //速度


@end







