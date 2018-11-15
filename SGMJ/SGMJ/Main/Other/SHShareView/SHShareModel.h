//
//  SHShareModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHShareModel : NSObject


//分享标题，只分享文本也是这个字段
@property (nonatomic, copy) NSString *title;

//描述内容
@property (nonatomic, copy) NSString *descr;

//缩略图
@property (nonatomic, strong) id thumbImage;

//链接
@property (nonatomic, copy) NSString *url;


@end
