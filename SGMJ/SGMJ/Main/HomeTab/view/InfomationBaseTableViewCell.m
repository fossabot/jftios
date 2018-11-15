//
//  InfomationBaseTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "InfomationBaseTableViewCell.h"

@interface InfomationBaseTableViewCell ()

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation InfomationBaseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.bottomView];
    }
    return self;
}


- (void)initUI {
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(leftArightMargin);
        make.right.mas_equalTo(-leftArightMargin);
        make.bottom.mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - lazy method

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
    }
    return _image;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = SH_TitleColor;
        _title.font = SH_FontSize(15);
        
    }
    return _title;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = SH_UnusableColor;
        _time.font = SH_FontSize(11);
    }
    return _time;
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = SH_GroupBackgroundColor;
    }
    return _bottomView;
}



@end
