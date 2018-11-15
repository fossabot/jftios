//
//  SHAnsweiFooterView.m
//  SGMJ
//
//  Created by 曾建国 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAnswerFooterView.h"

@interface SHAnswerFooterView ()

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation SHAnswerFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)comitBtnClick
{
    if (self.commitBlock) {
        self.commitBlock();
    }
}

- (void)layout
{
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(280, 44));
    }];
}

- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:158 / 255.0 blue:231 / 255.0 alpha:1];
//        _commitBtn.layer.masksToBounds = YES;
//        _commitBtn.layer.cornerRadius = 22;
//        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
//        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setImage:SHImageNamed(@"commitAnswer") forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(comitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commitBtn];
    }
    return _commitBtn;
}

@end
