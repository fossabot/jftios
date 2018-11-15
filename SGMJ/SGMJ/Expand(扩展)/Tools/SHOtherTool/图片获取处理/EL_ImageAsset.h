//
//  EL_ImageAsset.h
//  EasyLife365
//
//  Created by xiedong on 2017/5/4.
//  Copyright © 2017年 xiedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EL_ImageAsset : NSObject
/**
 压缩的图片
 **/
@property (nonatomic) UIImage *thumbnailImage;
/**
 图片的路径
 **/
@property (nonatomic) NSString *scaledImagePath;
@end
