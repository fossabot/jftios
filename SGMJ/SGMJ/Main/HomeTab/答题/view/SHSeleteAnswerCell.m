//
//  SHSeleteAnswerCell.m
//  SGMJ
//
//  Created by 曾建国 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSeleteAnswerCell.h"
#import "SHAnswerItemModel.h"

@interface SHSeleteAnswerCell ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIView *bigCycleView;

@property (nonatomic, strong) UIView *smallCycleView;

@property (nonatomic, strong) UILabel *answerAbcdL;
@property (nonatomic, strong) UILabel *answerL;

@property (nonatomic, strong) UIImageView *checkedView;

@end

@implementation SHSeleteAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        [self initUI];
    }
    return self;
}


#pragma mark --- initUI
- (void)initUI
{
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(3, contentMargin, 3, contentMargin));
    }];
    
//    [self.bigCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//        make.left.mas_equalTo(13);
//        make.centerY.mas_equalTo(self);
//    }];
    
//    [self.smallCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.bigCycleView);
//        make.centerX.mas_equalTo(self.bigCycleView);
//        make.size.mas_equalTo(CGSizeMake(10, 10));
//    }];
    
    [self.checkedView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-leftArightMargin);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.answerAbcdL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.backImageView).offset(contentMargin);
        make.top.mas_equalTo(self.backImageView).offset(3);
    }];
    
    [self.answerL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.answerAbcdL.mas_right).offset(3);
        make.top.mas_equalTo(self.backImageView).offset(3);
        make.bottom.mas_equalTo(self.backImageView).offset(-3);
        make.right.mas_equalTo(self.backImageView).offset(-3);
    }];
    
}

#pragma mark - setter

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    self.smallCycleView.hidden = !isSelected;
    self.backImageView.hidden = !isSelected;
    self.checkedView.hidden = !isSelected;
    self.answerAbcdL.textColor = isSelected ? SH_WhiteColor : SH_TitleColor;
    self.answerL.textColor = isSelected ? SH_WhiteColor : SH_TitleColor;
}

- (void)setQuestionStr:(NSString *)questionStr
{
    _questionStr = questionStr;
  
    self.answerL.text = questionStr;
}

- (void)setQuestionAbcd:(NSString *)questionAbcd {
    
    _questionAbcd = questionAbcd;
    self.answerAbcdL.text = questionAbcd;
}

#pragma mark --- lazying

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:SHImageNamed(@"cellBackImage")];
        _backImageView.hidden = YES;
        [self addSubview:_backImageView];
    }
    return _backImageView;
}

- (UIImageView *)checkedView {
    if (!_checkedView) {
        _checkedView = [[UIImageView alloc] initWithImage:SHImageNamed(@"checked")];
        _checkedView.contentMode = UIViewContentModeCenter;
        _checkedView.hidden = YES;
        [self addSubview:_checkedView];
    }
    return _checkedView;
}

- (UILabel *)answerAbcdL {
    if (!_answerAbcdL) {
        _answerAbcdL = [[UILabel alloc] init];
        _answerAbcdL.textColor = SH_TitleColor;
        _answerAbcdL.font = SH_TitleFont;
    }
    return _answerAbcdL;
}

- (UILabel *)answerL
{
    if (!_answerL) {
        _answerL = [[UILabel alloc]init];
        _answerL.numberOfLines = 0;
        _answerL.textColor = SH_TitleColor;
        _answerL.font = SH_TitleFont;
        [self addSubview:_answerL];
    }
    return _answerL;
}

//- (UIView *)bigCycleView
//{
//    if (!_bigCycleView) {
//        _bigCycleView = [[UIView alloc]init];
//        _bigCycleView.layer.masksToBounds = YES;
//        _bigCycleView.layer.cornerRadius = 10;
//        _bigCycleView.layer.borderColor = [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1].CGColor;
//        _bigCycleView.layer.borderWidth = 1;
//        [self addSubview:_bigCycleView];
//    }
//    return _bigCycleView;
//}
//
//- (UIView *)smallCycleView
//{
//    if (!_smallCycleView) {
//        _smallCycleView = [[UIView alloc]init];
//        _smallCycleView.layer.masksToBounds = YES;
//        _smallCycleView.layer.cornerRadius = 5;
//        _smallCycleView.backgroundColor = navColor;
//        _smallCycleView.hidden = YES;
//        [self addSubview:_smallCycleView];
//    }
//    return _smallCycleView;
//}



@end
