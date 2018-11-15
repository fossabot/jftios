//
//  SHRedPackageV.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHRedPackageV.h"

@implementation SHRedPackageV



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
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"reddelete"] forState:UIControlStateNormal];
    [self addSubview:_closeButton];
    [_closeButton addTarget:self action:@selector(closeRedPackageView) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-31);
        make.top.equalTo(self.mas_top).offset(115);
    }];
    
    _redImgView = [[UIImageView alloc] init];
    _redImgView.image = [UIImage imageNamed:@"homeRedPackage"];
    [self addSubview:_redImgView];
    [_redImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_closeButton.mas_bottom);
        make.left.equalTo(self.mas_left).offset(13);
        make.right.equalTo(self.mas_right).offset(-13);
        make.height.mas_equalTo(250);
        
    }];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.text = @"￥0.78元";
    _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:35.0f];;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_redImgView.mas_centerX);
        make.centerY.equalTo(_redImgView.mas_centerY).offset(-10);
        
    }];
    
    _textLabel = [[UILabel alloc] init];
    //_textLabel.text = @"已放入您的余额";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0f];
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_moneyLabel.mas_centerX);
        make.top.equalTo(_moneyLabel.mas_bottom).offset(10);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"终于等到您！点击领取，即可获得大红包！";
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.0f];
    _contentLabel.textColor = SHColorFromHex(0xfae25b);
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_redImgView.mas_centerX);
        make.width.mas_equalTo(200);
        make.bottom.equalTo(_redImgView.mas_bottom).offset(-10);
    }];
    
    
    _button = [[UIButton alloc] init];
    [_button setBackgroundColor:SHColorFromHex(0xfae25b)];
    _button.frame = CGRectMake(40, SHScreenH - 150, SHScreenW - 80, 50);
    [_button setTitle:@"领取" forState:UIControlStateNormal];
    [_button setTitleColor:SHColorFromHex(0xbf07bd) forState:UIControlStateNormal];
    _button.layer.cornerRadius = _button.height / 2;
    _button.clipsToBounds = YES;
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    
}

//点击按钮
- (void)buttonClick:(UIButton *)button
{
    if (self.redPacBlock) {
        self.redPacBlock(button.currentTitle);
        [self closeRedPackageView];
    }
    
    
}

/**
 *  展示
 */
- (void)showRedPackageView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    }];
}

/**
 *  消失
 */
- (void)closeRedPackageView
{
    [UIView animateWithDuration:.3f delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}















@end
