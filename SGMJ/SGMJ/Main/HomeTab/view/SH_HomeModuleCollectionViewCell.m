//
//  SH_HomeModuleCollectionViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_HomeModuleCollectionViewCell.h"

@implementation SH_HomeModuleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.contentView.backgroundColor = SH_WhiteColor;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.subtitle];
    [self.contentView addSubview:self.image];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-leftArightMargin);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(40.f*screenWidthRatio);
        make.centerY.equalTo(self.contentView);
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftArightMargin);
        make.right.mas_equalTo(self.image.mas_left).offset(-contentMargin);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-5);
    }];
    
    [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.title.mas_bottom).offset(contentMargin);
        make.left.equalTo(self.title);
        make.right.mas_equalTo(self.image.mas_left).offset(-contentMargin);
    }];
    
}



#pragma mark - lazy method

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = SH_TitleFont;
        _title.textColor = SH_TitleColor;
    }
    return _title;
}

- (UILabel *)subtitle {
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        _subtitle.font = SH_SubTitleFont;
        _subtitle.textColor = SH_SubtitleColor;
    }
    return _subtitle;
}

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _image;
}


@end
