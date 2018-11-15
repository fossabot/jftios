//
//  ImageUtil.h
//  baikudail
//  图片操作工具类
//  Created by Matrix AHQN on 12-8-17.
//  Copyright (c) 2012年 Channelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//hexValue eg: 0x555555
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//应用程序沙盒的documents目录
#define FILE_DEST_PATH      [NSHomeDirectory() stringByAppendingString:@"/Documents/"]


#define K_LITTLE_IAMGE_SIZE CGSizeMake(50, 50)

@interface ImageUtil : NSObject

#pragma mark 通过图片的url得到图片名称
+(NSString *) getPicName:(NSString *)picUrl;

/**
 *  创建一个png图片文件名
 *
 *  @return 文件名
 */
+ (NSString *)createImageFileName;

#pragma mark 通过图片的名称得到本地的存储路径
+(NSString *) getPicFilePath:(NSString *)picName;

#pragma mark 压缩图片
+ (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  等比压缩图片
 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage scale:(CGFloat)scale;

/**
 *  获取彩色图片的灰度图片
 */
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;

/**
 *  对原有图片进行压缩
 */
+ (UIImage *)comparessImageFromOriginalImage:(UIImage *)originalImage;
+ (NSData *)comparessImageDataFromOriginalImage:(UIImage *)originalImage;


/**
 *  采用drawinrect截取图片的一部分
 */
+ (UIImage *) image: (UIImage *) image fillSize: (CGSize) viewsize;

/**
 *  UIColor转UIImage
 *
 *  @param color
 *
 *  @return UIImage
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
