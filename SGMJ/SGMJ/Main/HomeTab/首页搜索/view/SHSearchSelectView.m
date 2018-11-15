//
//  SHSearchSelectView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/9/18.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSearchSelectView.h"

@interface SHSearchSelectView ()

@property (nonatomic, strong) UIButton *serviceButton;
@property (nonatomic, strong) UIButton *needButton;
@property (nonatomic, strong) UILabel *serviceL;
@property (nonatomic, strong) UILabel *needL;


@end

@implementation SHSearchSelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layout
{
    
}



#pragma mark - lazying
- (UIButton *)serviceButton
{
    if (!_serviceButton) {
        _serviceButton = [[UIButton alloc] init];
        _serviceButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_serviceButton setTitle:@"服务" forState:UIControlStateNormal];
        [self addSubview:_serviceButton];
    }
    return _serviceButton;
}
















@end
