//
//  SH_AlertView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SH_AlertView;
@protocol SHAlertViewDelegate <NSObject>
@optional
- (void)shAlertView:(SH_AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface SH_AlertView : UIView

@property (nonatomic, weak) id <SHAlertViewDelegate> delegate;

/**
 *  初始化AlertView
 *  @param  title 标题
 *  @param message  内容
 *  @param cancelTitle 取消按钮
 *  @param otherBtnTitle 确定按钮
 *  @return return value description
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle;

- (void)show;










@end
