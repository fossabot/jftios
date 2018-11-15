//
//  SHButton.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHButton.h"

@implementation SHButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect retValue = CGRectMake(0,self.frame.size.height-25,contentRect.size.width,25);
    return retValue;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect retValue = CGRectMake(self.frame.size.width/2 - 30,5,60,60);
    return retValue;
}













@end






