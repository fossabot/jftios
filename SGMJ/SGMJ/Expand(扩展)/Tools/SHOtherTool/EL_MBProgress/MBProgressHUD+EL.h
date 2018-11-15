//
//  MBProgressHUD+EL.h
//  EasyLife365
//
//  Created by xiedong on 2017/4/21.
//  Copyright © 2017年 xiedong. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (EL)
/**
 显示无文字的等待框
 @param view 等待框的view
 **/
+ (void)showWaitingAlertViewInView:(UIView *)view;

/**
 显示有文字的等待框
 @param text 等待文字
 @param view 等待框的view
 **/
+ (void)showWaitingAlertViewWithText:(NSString *)text InView:(UIView *)view;

/**
 隐藏等待框
 **/
+ (void)dismissWaitingAlertView;

/**
 显示成功的提示框 带图片 1s后自动隐藏
 @param text 成功的提示文字
 **/
+ (void)showSuccessAlertViewWithText:(NSString *)text;

/**
 显示失败的提示框 带图片 1s后自动隐藏
 @param text 失败的提示文字
 **/
+ (void)showFailureAlertViewWithText:(NSString *)text;

/**
 显示只带文字的提示框
 @param text 提示文字
 **/
+ (void)showAlertViewWithText:(NSString *)text;

/**
 检查网络
 **/
+ (BOOL)connectedNetwork;

/**
 显示无网络的提示框
 **/
+ (void)showNoNetworkAlertView;
@end
