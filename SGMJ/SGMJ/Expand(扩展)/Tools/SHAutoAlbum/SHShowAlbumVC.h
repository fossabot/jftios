//
//  SHShowAlbumVC.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//


/**
 *  显示详细相册页面
 */
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum {
    ENUM_Photo,                 //只显示图片
    ENUM_Camera                 //显示图片和相机
} ENUM_ShowLayoutStyle;


@interface SHShowAlbumVC : UIViewController

//获取相册组--页面展示相册组的照片
@property (nonatomic, strong) ALAssetsGroup *group;

//相册的背景色（默认黑色）
@property (nonatomic, strong) UIColor *color;

//一行显示几张图片，默认四个
@property (nonatomic, assign) NSInteger listCount;

//显示的形式
@property (nonatomic, assign) NSInteger showStyle;

@end
