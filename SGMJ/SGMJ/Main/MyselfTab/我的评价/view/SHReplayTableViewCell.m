//
//  SHReplayTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHReplayTableViewCell.h"
#import "SHReplayModel.h"

@interface SHReplayTableViewCell ()

@property (nonatomic, strong) UILabel *replayL;
@property (nonatomic, strong) UIView *labelBgV;

@end

@implementation SHReplayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self stepUI];
    }
    return self;
}


- (void)stepUI
{
    
    _labelBgV = [[UIView alloc] init];
    _labelBgV.backgroundColor = SHColorFromHex(0xf2f2f2);
    [self addSubview:_labelBgV];
    [_labelBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    _replayL = [[UILabel alloc] init];
    _replayL.numberOfLines = 0;
    _replayL.font = [UIFont systemFontOfSize:14.0];
    [_replayL sizeToFit];
    [_labelBgV addSubview:_replayL];
    [_replayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_labelBgV.mas_left).offset(10);
        make.top.equalTo(_labelBgV.mas_top).offset(10);
        make.right.equalTo(_labelBgV.mas_right).offset(-10);
        make.bottom.equalTo(_labelBgV.mas_bottom).offset(-10);
        
    }];
    
}

- (void)setReplayModel:(SHReplayModel *)replayModel
{
    _replayModel = replayModel;
    
    //1.服务者回复：。。。0.客户回复:。。。isCustomer
    if (replayModel.isCustomer == 0) {
        NSString *foreString = @"客户回复：";
        NSString *foreRightStr = [NSString stringWithFormat:@"%@", replayModel.content];
        _replayL.text = [NSString stringWithFormat:@"%@%@", foreString, foreRightStr];
        NSMutableAttributedString *forecastString = [[NSMutableAttributedString alloc] initWithString:_replayL.text];
        NSRange range2 = [[forecastString string] rangeOfString:foreString];
        [forecastString addAttribute:NSForegroundColorAttributeName value:SHColorFromHex(0xf5ac5d) range:range2];
        _replayL.attributedText = forecastString;
    } else {
        NSString *foreString = @"服务者回复：";
        NSString *foreRightStr = [NSString stringWithFormat:@"%@", replayModel.content];
        _replayL.text = [NSString stringWithFormat:@"%@%@", foreString, foreRightStr];
        NSMutableAttributedString *forecastString = [[NSMutableAttributedString alloc] initWithString:_replayL.text];
        NSRange range2 = [[forecastString string] rangeOfString:foreString];
        [forecastString addAttribute:NSForegroundColorAttributeName value:navColor range:range2];
        _replayL.attributedText = forecastString;
    }
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_replayL sizeToFit];
}




- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
