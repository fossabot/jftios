//
//  SHShowGroupAlbumVC.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//


/**
 *  显示相册分组
 */
#import <UIKit/UIKit.h>

typedef enum {
    ENUM_AllOfPhoto,            //只显示图片
    ENUM_PhotoAndCamera         //显示图片和相机
} ENUM_ShowAlbumStyle;

@interface SHShowGroupAlbumVC : UIViewController

//显示照片的模式
@property (nonatomic, assign) NSInteger showAlbumStyle;

//显示照片的背景色
@property (nonatomic, strong) UIColor *albumColor;

//显示照片的一行几个
@property (nonatomic, assign) NSInteger listCount;




@end









