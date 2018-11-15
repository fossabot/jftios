//
//  SHRegularView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHRegularView.h"

@implementation SHRegularView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        [self stepUI];
    }
    return self;
}

- (void)stepUI
{
    
    
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(SHScreenW - 80);
        make.height.mas_equalTo(SHScreenH / 2);
    }];
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"reddelete"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeRegularView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgView.mas_top).offset(-10);
        make.right.equalTo(_bgView.mas_right).offset(20);
        make.width.with.height.mas_equalTo(40);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = SHColorFromHex(0xff4545);
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"—————— 签到规则 ——————";
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.top.equalTo(_bgView.mas_top).offset(10);
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.text = @"家服通红包是家服通平台提供给家服通新老会员的额外现金回馈领取红包只要完成相关红包任务即可，所有的红包任务全都完成才在平台使用交易或提现，其中任何一步没有完成均不可使用交易或体现，且每次登录都会自动跳转到红包任务界面家服通红包是家服通平台提供给家服通新老会员的额外现金回馈领取红包只要完成相关红包任务即可，所有的红包任务全都完成才在平台使用交易或提现，其中任何一步没有完成均不可使用交易或体现，且每次登录都会自动跳转到红包任务界面家服通红包是家服通平台提供给家服通新老会员的额外现金回馈领取红包只要完成相关红包任务即可，所有的红包任务全都完成才在平台使用交易或提现，其中任何一步没有完成均不可使用交易或体现，且每次登录都会自动跳转到红包任务界面家服通红包是家服通平台提供给家服通新老会员的额外现金回馈、\n领取红包只要完成相关红包任务即可，所有的红包任务全都完成才在平台使用交易或提现，其中任何一步没有完成均不可使用交易或体现，且每次登录都会自动跳转到红包任务界面家服通红包是家服通平台提供给家服通新老会员的额外现金回馈领取红包只要完\n成相关红包任务即可，所有的红包任务全都完成才在平台使用交易或提现，其中任何一步没有完成均不可使用交易或体现，且每次登录都会自动跳转到红包任务界面家服通红包是家服通平台提供给家服通新老会员的额外现金回馈领取红包只要完成相关红包任务即可，所有的红包任务全都完成才在平台使用交易或提现，其中任何一步没有完成均不可使用交易或体现，且每次登录都会自动跳转到红包任务界面";
    
    _textView.userInteractionEnabled = YES;
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_bgView.mas_left).offset(10);
        make.right.equalTo(_bgView.mas_right).offset(-10);
        make.bottom.equalTo(_bgView.mas_bottom).offset(-10);
    }];
    
    
    
    
    
}



- (void)showRegularView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    }];
}


- (void)closeRegularView
{
    [UIView animateWithDuration:.3f delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}


@end
