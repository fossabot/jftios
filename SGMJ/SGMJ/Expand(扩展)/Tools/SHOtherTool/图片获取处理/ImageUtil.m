//
//  ImageUtil.m
//  baikudail
//  图片操作工具类
//  Created by Matrix AHQN on 12-8-17.
//  Copyright (c) 2012年 Channelsoft. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

#pragma mark 通过图片的url得到图片名称
+(NSString *) getPicName:(NSString *)picUrl
{
    NSString *regExStr = @"[^0-9a-zA-Z.]";
    NSString *name = [picUrl stringByReplacingOccurrencesOfString:regExStr withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, picUrl.length)];
    return name;
}

/**
 *  创建一个png图片文件名
 *
 *  @return 文件名
 */
+ (NSString *)createImageFileName
{
    return [[NSString createDbId] stringByAppendingString:@".png"];
}

#pragma mark 通过图片的名称得到本地的存储路径
+(NSString *) getPicFilePath:(NSString *)picName
{
    return [FILE_DEST_PATH stringByAppendingString:picName];
}

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

/**
 *  等比压缩图片
 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage scale:(CGFloat)scale
{
    CGSize orginalSize = originalImage.size;
    CGSize newSize = CGSizeMake(orginalSize.width * scale, orginalSize.height * scale);
    UIGraphicsBeginImageContext(newSize);
    [originalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  获取彩色图片的灰度图片
 */
+ (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}



/**
 *  采用drawinrect截取图片的一部分
 */
+ (UIImage *) image: (UIImage *) image fillSize: (CGSize) viewsize
{
	CGSize size = image.size;
	CGFloat scalex = viewsize.width / size.width;
	CGFloat scaley = viewsize.height / size.height;
	CGFloat scale = MAX(scalex, scaley);
	UIGraphicsBeginImageContext(viewsize);
	CGFloat width = size.width * scale;
	CGFloat height = size.height * scale;
	float dwidth = ((viewsize.width - width) / 2.0f);
	float dheight = ((viewsize.height - height) / 2.0f);
	CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
	[image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

/**
 *  UIColor转UIImage
 *
 *  @param color
 *
 *  @return UIImage
 */
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  对原有图片进行压缩
 */
+ (UIImage *)comparessImageFromOriginalImage:(UIImage *)originalImage
{
    return [UIImage imageWithData:[self comparessImageDataFromOriginalImage:originalImage]];
}

/**
 *  对原有图片进行压缩
 */
+ (NSData *)comparessImageDataFromOriginalImage:(UIImage *)originalImage
{
    NSString *compress = @"200";
    int maxSize = 300;
    if (compress) {
        maxSize = compress.intValue;
    }
    NSData *data = nil;
    //@autoreleasepool {
    CGSize size = originalImage.size;
    CGFloat maxLength = MAX(size.width, size.height);
    if (maxLength > 1280) {
        // 计算压缩比例，并进行压缩
        CGFloat scale = 1280.0f / maxLength;
        originalImage = [ImageUtil imageWithOriginalImage:originalImage scale:scale];
    }
    SHLog(@"压缩像素后的图片尺寸:%f,%f", originalImage.size.width, originalImage.size.height);
    data = UIImageJPEGRepresentation(originalImage, 1.0);

    long maxSizeF = maxSize * 1024;
    CGFloat press = 0.7;
    int sizeTmp = (int)(data.length / maxSizeF);
    if (sizeTmp >= 3 && sizeTmp <= 4) {
        press = 0.5;
    } else if (sizeTmp >= 4) {
        press = 0.3;
    }
    int count = 0;
    if (data.length > maxSizeF) {
        while (YES) {
            if (count > 3) {
                break;
            }
            count++;
            data = UIImageJPEGRepresentation([UIImage imageWithData:data], press);
            if (data.length <= maxSizeF) {
                break;
            }
        }
    }
    //}
    return data;
}

@end
