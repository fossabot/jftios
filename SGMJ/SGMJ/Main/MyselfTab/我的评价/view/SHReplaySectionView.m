//
//  SHReplaySectionView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHReplaySectionView.h"


@interface SHReplaySectionView ()

@property (nonatomic, strong) UIImageView *imageV;


@end


@implementation SHReplaySectionView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self stepUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;

}

- (void)stepUI
{
    
    _imageV = [[UIImageView alloc] init];
    _imageV.image = [UIImage imageNamed:@"comments"];
    [self addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(13);
    }];
    
    _sectionLabel = [[UILabel alloc] init];
    _sectionLabel.text = @"暂无回复";
    _sectionLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_sectionLabel];
    [_sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_imageV.mas_centerY);
        make.left.equalTo(_imageV.mas_right).offset(10);
    }];
}





@end
