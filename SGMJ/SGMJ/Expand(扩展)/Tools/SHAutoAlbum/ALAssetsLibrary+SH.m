//
//  ALAssetsLibrary+SH.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ALAssetsLibrary+SH.h"

@implementation ALAssetsLibrary (SH)

/**
 *  获得照相后的图片
 */
- (void)afterCameraAsset:(void (^)(ALAsset *))block
{
    [self enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            //NSEnumerationReverse 遍历方式
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    if (block) {
                        block(result);
                    }
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    } failureBlock:^(NSError *error) {
        if (error) {
            SHLog(@"相机图片错误，%@", error)
        }
    }];
}

/**
 *  计算有几个相册
 */
- (void)countOfAlbumGroup:(void (^)(ALAssetsGroup *))block
{
    [self enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (block) {
                block(group);
            }
        }
    } failureBlock:^(NSError *error) {
        SHLog(@"获取相册错误，%@", error)
    }];
}

/**
 *  获得一个相册有多少照片
 */
- (void)callAllPhoto:(ALAssetsGroup *)group result:(void (^)(SHSelfImage *))block
{
    //获得所有图片资源
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            SHSelfImage *image = [[SHSelfImage alloc] initWithCGImage:[result thumbnail]];
            image.asset = result;
            block(image);
        }
    }];
}












@end
