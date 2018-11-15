//
//  UIButton+SHButton.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "UIButton+SHButton.h"

static NSTimer *_countTimer;
static NSTimeInterval _count;
static NSString *_title;


@implementation UIButton (SHButton)


- (void)sh_beginCountDownWithDuration:(NSTimeInterval)duration
{
    _title = self.titleLabel.text;
    _count = duration;
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sh_updateTitle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
    
    self.titleLabel.textColor = [UIColor lightGrayColor];
    
}

- (void)showNetUrlImageWithUrl:(NSString *)urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    // 根据图片的url下载图片数据
    dispatch_queue_t xrQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
    dispatch_async(xrQueue, ^{
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setBackgroundImage:img forState:UIControlStateNormal];
        });
        
    });
}

- (void)sh_stopCountDown
{
    [_countTimer invalidate];
    _countTimer = nil;
    _count = SHCountDownSeconds;
    [self setTitle:_title forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}

- (void)sh_updateTitle
{
    NSString *countString = [NSString stringWithFormat:@"%lis后失效", (long)_count - 1];
    self.userInteractionEnabled = NO;
    [self setTitle:countString forState:UIControlStateNormal];
    if (_count-- <= 1.0) {
        [self sh_stopCountDown];
        [self setTitleColor:SHColorFromHex(0x4a4c5b) forState:UIControlStateNormal];
    }
}


- (void)setCornerRadiusWithBackgroundColor:(UIColor *)color
{
    self.layer.cornerRadius = self.height / 2;
    self.clipsToBounds = YES;
    self.backgroundColor = color;
}


@end
