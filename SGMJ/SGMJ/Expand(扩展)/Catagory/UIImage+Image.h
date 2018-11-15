//
//  UIImage+Image.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

/**
 *  根据颜色生成一张图片
 *  @param color 提供的颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;


@end
