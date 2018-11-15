//
//  SHTimeLabel.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHTimeLabel.h"


@interface SHTimeLabel ()


@property (nonatomic, strong) NSTimer *timer;

@end



@implementation SHTimeLabel

- (void)dealloc {
    [self.timer invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = SH_FontSize(14);
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blackColor];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timeHeadle
{
    self.second--;
    if (self.second == -1) {
        self.second = 59;
        self.minute--;
        if (self.minute == -1) {
            self.minute = 59;
            self.hour--;
        }
    }
    if (self.hour > 0) {
        
    }
}









@end




