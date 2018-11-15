//
//  SHUpdateViewAlert.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHUpdateViewAlert : UIView

/**
 *  添加版本更新提示
 *  @param version 版本号
 *  @param descriptions 版本更新内容（数组）
 *  description 格式如 @[@"1.xxx",@"2.xxx"]
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version descriptArray:(NSArray *)descriptions;

/**
 *  添加版本更新提示
 *  @param version 版本更新内容（数组）
 *  @param description 版本更新内容（字符串）
 *  description 格式如 @"1.xxx\n2.xxx"
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version descriptString:(NSString *)description;



@end
