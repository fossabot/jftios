//
//  NSCalendar+YYCommentDate.h
//  BuDeJie
//
//  Created  on 16/9/19.
//  Copyright © 2016年. All rights reserved.
//  时间表述方式 : 去年/一月前/昨天前/昨天/今天/一小时前/一分钟前

#import <Foundation/Foundation.h>

@interface NSCalendar (SHCommentDate) //original

/**
 *  根据传入参数时间 参照当前时间 更改原始时间的表述方式
 *
 *  @param originalDate 原始时间
 *  @param dateFormat   传入原始日期的格式 such as @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 返回一个根据现在时间间隔 处理过的 日期/时间表示方法
 */
+ (NSString *)commentDateByOriginalDate:(NSString *)originalDate withDateFormat:(NSString *)dateFormat;

/**
 *  根据传入参数时间 参照当前时间 更改原始时间的表述方式
 *
 *  @param originalDate 原始时间
 *  @param dateFormat   传入原始日期的格式 such as @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 返回一个根据现在时间间隔 处理过的 日期/时间表示方法
 */
+ (NSString *)niuCommentDateByOriginalDate:(NSString *)originalDate withDateFormat:(NSString *)dateFormat;

@end
