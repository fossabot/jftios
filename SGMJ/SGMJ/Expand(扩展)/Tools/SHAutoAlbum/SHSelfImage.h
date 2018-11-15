//
//  SHSelfImage.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

/**
 *  用于存储相册图片，附有一个asset信息，用于图片的其他处理
 */

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface SHSelfImage : UIImage

/**
 *  可能需要的图片信息
 */
@property (nonatomic, strong) ALAsset *asset;

@end
