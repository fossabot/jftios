//
//  SHAnswerHeaderView.m
//  SGMJ
//
//  Created by 曾建国 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAnswerHeaderView.h"
#import "SDCycleScrollView.h"
#import "SHAdverDetailModel.h"

@interface SHAnswerHeaderView ()

//轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleView;

//标题
@property (nonatomic, strong) UILabel *titleL;
//内容
@property (nonatomic, strong) UILabel *contentL;
//奖励
@property (nonatomic, strong) UILabel *rewardL;
//剩余数量
@property (nonatomic, strong) UILabel *overL;
@property (nonatomic, strong) UIImageView *overIV;
//投放
@property (nonatomic, strong) UILabel *putInL;
@property (nonatomic, strong) UIImageView *putInIV;
//灰色区域
@property (nonatomic, strong) UIView *grayView;
//回答
@property (nonatomic, strong) UILabel *answerL;

@end

@implementation SHAnswerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark --- setting

- (void)setModel:(SHAdverDetailModel *)model
{
    _model = model;
    self.contentL.text = model.introduce;
    self.titleL.text = model.title;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSForegroundColorAttributeName : SH_RedMoneyColor, NSFontAttributeName : SH_MoneyLogoFont}];
    
    NSAttributedString * attr1 = [[NSAttributedString alloc] initWithString:model.profit attributes:@{NSForegroundColorAttributeName : SH_RedMoneyColor, NSFontAttributeName : SH_MoneyStringFont}];
    [attr appendAttributedString:attr1];
    self.rewardL.attributedText = attr;
    self.putInL.text = [NSString stringWithFormat:@"%ld份",model.deliveryNum];
    self.overL.text = [NSString stringWithFormat:@"%ld份",model.surplusNum];
    self.cycleView.imageURLStringsGroup = model.pics;
}

#pragma mark --- layout
- (void)layout
{
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(169);
    }];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.cycleView.mas_bottom).offset(13);
    }];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
    }];
    [self.rewardL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(23);
    }];
    [self.overL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(self.rewardL.mas_top);
        
    }];
    [self.overIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.overL.mas_left).offset(-2);
        make.top.mas_equalTo(self.overL).offset(4);
        make.centerY.mas_equalTo(self.overL);
    }];
    [self.putInL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.overIV.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.rewardL.mas_centerY);
    }];
    [self.putInIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.putInL.mas_left).offset(-2);
        make.top.mas_equalTo(self.putInL).offset(4);
        make.centerY.mas_equalTo(self.putInL);
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.rewardL.mas_bottom).offset(15);
        make.height.mas_equalTo(12);
    }];
    [self.answerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.grayView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark --- lazying

- (SDCycleScrollView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"mybanner"]];
//        _cycleView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
        _cycleView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleView.autoScrollTimeInterval = 3;
        _cycleView.showPageControl = YES;
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        _cycleView.backgroundColor = [UIColor redColor];
        [self addSubview:_cycleView];
    }
    return _cycleView;
}

- (UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"title";
        _titleL.textColor = [UIColor colorWithRed:63 / 255.0 green:63 / 255.0 blue:63 / 255.0 alpha:1];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)contentL
{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.numberOfLines = 0;
        _contentL.text = @"content";
        _contentL.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
        _contentL.font = [UIFont systemFontOfSize:13];
        [self addSubview:_contentL];
    }
    return _contentL;
}

- (UILabel *)rewardL
{
    if (!_rewardL) {
        _rewardL = [[UILabel alloc]init];
        _rewardL.text = @"答题奖励：￥0.8";
        _rewardL.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
        _rewardL.font = [UIFont systemFontOfSize:13];
        [self addSubview:_rewardL];
    }
    return _rewardL;
}

- (UILabel *)overL
{
    if (!_overL) {
        _overL = [[UILabel alloc]init];
        _overL.text = @"剩余xx份";
        _overL.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
        _overL.font = [UIFont systemFontOfSize:13];
        [self addSubview:_overL];
    }
    return _overL;
}

- (UILabel *)putInL
{
    if (!_putInL) {
        _putInL = [[UILabel alloc]init];
        _putInL.text = @"投放xx份";
        _putInL.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
        _putInL.font = [UIFont systemFontOfSize:13];
        [self addSubview:_putInL];
    }
    return _putInL;
}

- (UIImageView *)overIV
{
    if (!_overIV) {
        _overIV = [[UIImageView alloc] init];
        _overIV.image = [UIImage imageNamed:@"remaining"];
        [self addSubview:_overIV];
    }
    return _overIV;
}

- (UIImageView *)putInIV
{
    if (!_putInIV) {
        _putInIV = [[UIImageView alloc] init];
        _putInIV.image = [UIImage imageNamed:@"putonthe"];
        [self addSubview:_putInIV];
    }
    return _putInIV;
}

- (UIView *)grayView
{
    if (!_grayView) {
        _grayView = [[UIView alloc]init];
        _grayView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        [self addSubview:_grayView];
    }
    return _grayView;
}

- (UILabel *)answerL
{
    if (!_answerL) {
        _answerL = [[UILabel alloc]init];
        _answerL.text = @"    答题";
        _answerL.textColor = [UIColor colorWithRed:63 / 255.0 green:63 / 255.0 blue:63 / 255.0 alpha:1];
        _answerL.font = [UIFont systemFontOfSize:17];
        [self addSubview:_answerL];
    }
    return _answerL;
}

@end
