//
//  SHAnswerSectionHeaderView.m
//  SGMJ
//
//  Created by 曾建国 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAnswerSectionHeaderView.h"

@interface SHAnswerSectionHeaderView ()

@property (nonatomic, strong) UILabel *qustionL;
@property (nonatomic, strong) UIImageView *leftImageView;
@end

@implementation SHAnswerSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame section:(NSInteger)section quesionStr:(NSString *)qustionstr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutWithSection:section quesionStr:qustionstr];
    }
    return self;
}

- (void)layoutWithSection:(NSInteger)section quesionStr:(NSString *)qustionstr
{
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftArightMargin);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(35);
    }];

    [self.qustionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(contentMargin);
        make.right.mas_equalTo(-leftArightMargin);
        make.centerY.mas_equalTo(self);
    }];
    
     NSString *image = [NSString stringWithFormat:@"question%ld",section+1];
    self.leftImageView.image = SHImageNamed(image);
    self.qustionL.text = qustionstr;
}

- (UILabel *)qustionL
{
    if (!_qustionL) {
        _qustionL = [[UILabel alloc]init];
        _qustionL.numberOfLines = 0;
        _qustionL.textColor = SH_TitleColor;
        _qustionL.font = SH_SubTitleFont;
        [self addSubview:_qustionL];
    }
    return _qustionL;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}


@end
