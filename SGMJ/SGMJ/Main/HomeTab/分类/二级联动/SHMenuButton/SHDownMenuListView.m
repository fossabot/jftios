//
//  SHDownMenuListView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHDownMenuListView.h"
#import "SHMaskingView.h"

@interface SHDownMenuListView ()


@end

@implementation SHDownMenuListView


- (SHMaskingView *)maskingView
{
    if (!_maskingView) {
        _maskingView = [[SHMaskingView alloc] init];
        _maskingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    }
    return _maskingView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.maskingView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.maskingView dismiss];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.maskingView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}




@end








