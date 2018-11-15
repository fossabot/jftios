//
//  SHAnswerHeaderViewSub.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAnswerHeaderViewSub.h"
#import "SHAdverDetailModel.h"

@interface SHAnswerHeaderViewSub ()

@property (nonatomic, strong) UIImageView *headerImage;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

//奖励
@property (nonatomic, strong) UILabel *rewardL;
@property (nonatomic, strong) UILabel *rewardTip;
//剩余数量
@property (nonatomic, strong) UILabel *overL;
@property (nonatomic, strong) UILabel *overTip;

//投放
@property (nonatomic, strong) UILabel *putInL;
@property (nonatomic, strong) UILabel *putInTip;


//灰色区域
@property (nonatomic, strong) UIView *grayView;

@end

@implementation SHAnswerHeaderViewSub

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SHScreenW, SHScreenW/2+90+8)];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}




#pragma mark - setter

- (void)setModel:(SHAdverDetailModel *)model
{
    _model = model;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSForegroundColorAttributeName : SH_RedMoneyColor, NSFontAttributeName : SH_MoneyLogoFont}];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:model.profit attributes:@{NSForegroundColorAttributeName : SH_RedMoneyColor, NSFontAttributeName : SH_MoneyStringFont}]];
    
    self.rewardL.attributedText = attr;
    self.putInL.text = [NSString stringWithFormat:@"%ld",model.deliveryNum];
    self.overL.text = [NSString stringWithFormat:@"%ld",model.surplusNum];
    self.headerImage.image = SHImageNamed(@"lets_answer");
}

#pragma mark --- initUI
- (void)initUI
{
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(SHScreenW*moduleRatio);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(SHScreenW*0.4);
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(contentMargin);
//        make.bottom.mas_equalTo(-contentMargin);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(1);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(SHScreenW*0.7);
        make.top.width.height.mas_equalTo(self.line1);
    }];

    [self.rewardL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.line1);
        make.centerX.mas_equalTo(self.mas_left).offset(SHScreenW*0.2);
//        make.left.mas_equalTo(self);
//        make.right.mas_equalTo(self.line1.mas_left);
    }];
    
    [self.rewardTip mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.rewardL);
//        make.left.mas_equalTo(self);
//        make.right.mas_equalTo(self.line1.mas_left);
        make.bottom.mas_equalTo(self.line1);
    }];
    
    [self.putInL mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.mas_left).offset(SHScreenW*0.55);
//        make.left.mas_equalTo(self.line1.mas_right);
//        make.right.mas_equalTo(self.line2.mas_left);
        make.top.mas_equalTo(self.line1);
    }];
    
    [self.putInTip mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.putInL);
//        make.left.mas_equalTo(self.line1.mas_right);
//        make.right.mas_equalTo(self.line2.mas_left);
        make.bottom.mas_equalTo(self.line1);
    }];
    
    [self.overL mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.mas_left).offset(SHScreenW*0.85);
//        make.left.mas_equalTo(self.line2.mas_right);
//        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.line1);
    }];
    
    [self.overTip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.overL);
//        make.left.mas_equalTo(self.line2.mas_right);
//        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.line1);
    }];
   
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
}

#pragma mark --- lazying

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        [self addSubview:_line1];
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        [self addSubview:_line2];
    }
    return _line2;
}

- (UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] init];
        _headerImage.image = SHImageNamed(@"letsanswer");
        _headerImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_headerImage];
    }
    return _headerImage;
}


- (UILabel *)rewardL
{
    if (!_rewardL) {
        _rewardL = [[UILabel alloc] init];
        _rewardL.textColor = SH_TitleColor;
        _rewardL.font = SH_LargeTitleFont;
        _rewardL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rewardL];
    }
    return _rewardL;
}

- (UILabel *)rewardTip
{
    if (!_rewardTip) {
        _rewardTip = [[UILabel alloc] init];
        _rewardTip.text = @"奖励金额";
        _rewardTip.textColor = SH_SubtitleColor;
        _rewardTip.font = SH_SubTitleFont;
        _rewardTip.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rewardTip];
    }
    return _rewardTip;
}

- (UILabel *)overL
{
    if (!_overL) {
        _overL = [[UILabel alloc] init];
        _overL.textColor = SH_TitleColor;
        _overL.font = SH_LargeTitleFont;
        _overL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_overL];
    }
    return _overL;
}

- (UILabel *)overTip
{
    if (!_overTip) {
        _overTip = [[UILabel alloc] init];
        _overTip.text = @"剩余";
        _overTip.textColor = SH_SubtitleColor;
        _overTip.font = SH_SubTitleFont;
        _overTip.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_overTip];
    }
    return _overTip;
}

- (UILabel *)putInL
{
    if (!_putInL) {
        _putInL = [[UILabel alloc] init];
        _putInL.textColor = SH_SubtitleColor;
        _putInL.font = SH_LargeTitleFont;
        _putInL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_putInL];
    }
    return _putInL;
}


- (UILabel *)putInTip
{
    if (!_putInTip) {
        _putInTip = [[UILabel alloc] init];
        _putInTip.text = @"投放";
        _putInTip.textColor = SH_SubtitleColor;
        _putInTip.font = SH_SubTitleFont;
        _putInTip.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_putInTip];
    }
    return _putInTip;
}

- (UIView *)grayView
{
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = SH_GroupBackgroundColor;
        [self addSubview:_grayView];
    }
    return _grayView;
}



@end
