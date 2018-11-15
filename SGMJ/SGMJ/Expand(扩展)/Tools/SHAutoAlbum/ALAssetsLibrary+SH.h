//
//  ALAssetsLibrary+SH.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

/**
 *  拿出公共使用的方法
 *  @param SH   SH  description
 *  @return return value description
 */
#import <AssetsLibrary/AssetsLibrary.h>
#import "SHSelfImage.h"
@interface ALAssetsLibrary (SH)

/**
 *  获得照相后的图片
 */
- (void)afterCameraAsset:(void(^)(ALAsset *asset))block;

/**
 *  计算有几个相册
 */
- (void)countOfAlbumGroup:(void(^)(ALAssetsGroup *shGroup))block;

/**
 *  获得一个相册有多少照片
 */
- (void)callAllPhoto:(ALAssetsGroup *)group result:(void(^)(SHSelfImage *image))block;



@end
