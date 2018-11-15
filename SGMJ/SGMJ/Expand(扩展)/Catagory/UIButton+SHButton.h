//
//  UIButton+SHButton.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SHButton)


- (void)sh_beginCountDownWithDuration:(NSTimeInterval)duration;

- (void)sh_stopCountDown;


- (void)setCornerRadiusWithBackgroundColor:(UIColor *)color;


- (void)showNetUrlImageWithUrl:(NSString *)urlStr;


@end
