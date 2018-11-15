//
//  SH_SectionView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_SectionView.h"
#import "BAButton.h"


@interface SH_SectionView ()

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation SH_SectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 50)];
    if (self) {

        self.backgroundColor = SH_WhiteColor;
        [self addSubview:self.imageView];
        [self addSubview:self.title];
        [self addSubview:self.moreButton];
        [self addSubview:self.bottomView];
    }
    return self;
}


- (void)moreButtonClick {
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
//    _moreButton.ba_buttonLayoutType = BAKit_ButtonLayoutTypeCenterImageRight;
}


#pragma mark - lazy method

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    }
    return _imageView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 150, 20)];
        _title.font = SH_LargeTitleFont;
        _title.textColor = SH_TitleColor;
    }
    return _title;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.titleLabel.font = SH_SubTitleFont;
        _moreButton.frame = CGRectMake(SHScreenW - 60, 15, 50, 24);
        [_moreButton setTitleColor:SHColorFromHex(0x409aff) forState:UIControlStateNormal];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 24, 0, -24)];
    }
    return _moreButton;
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, SHScreenW-30, 1)];
        _bottomView.backgroundColor = SH_GroupBackgroundColor;
    }
    return _bottomView;
}


@end
