//
//  SH_HomeCategoryViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_HomeCategoryViewCell.h"

@interface SH_HomeCategoryViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation SH_HomeCategoryViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (BOOL)isHighlighted {
    return NO;
}

- (void)initUI {
    
//    int R = (arc4random() % 256) ;
//    int G = (arc4random() % 256) ;
//    int B = (arc4random() % 256) ;
//    self.backgroundColor = [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1.f];
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(30*screenWidthRatio);
//        make.left.top.right.mas_equalTo(self.contentView);
//        make.height.mas_equalTo(self.contentView.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
//        make.bottom.mas_equalTo(self.contentView);
    }];
}


#pragma mark - setter

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

#pragma mark - lazy method

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = SH_MoneyLogoFont;
        _titleLabel.textColor = SH_TitleColor;
    }
    return _titleLabel;
}



@end
