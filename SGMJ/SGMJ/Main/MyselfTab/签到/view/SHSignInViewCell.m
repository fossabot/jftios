//
//  SHSignInViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSignInViewCell.h"
#import "SHSignInModel.h"

@interface SHSignInViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;



@end
@implementation SHSignInViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _colorLabel.layer.cornerRadius = _colorLabel.height / 2;
    _colorLabel.clipsToBounds = YES;
    _isSignLabel.layer.cornerRadius = _isSignLabel.height / 2;
    _isSignLabel.clipsToBounds = YES;
    
}

- (void)setSignInModel:(SHSignInModel *)signInModel
{
    _signInModel = signInModel;
    
    if (signInModel.flag == 1) {
        _isSignLabel.text = @"未签到";
        _contentLabel.text = @"无签到记录";
        _isSignLabel.backgroundColor = SHColorFromHex(0x94D267);
        _colorLabel.backgroundColor = SHColorFromHex(0x94D267);
        _moneyLabel.text = @"无效益";
    } else if (signInModel.flag == 0) {
        _isSignLabel.text = @"每日签到";
        _isSignLabel.backgroundColor = SHColorFromHex(0xFE6316);
        _contentLabel.text = [NSString stringWithFormat:@"今日签到\+%@元", signInModel.money];
        _colorLabel.backgroundColor = SHColorFromHex(0xFE6316);
        _moneyLabel.text = [NSString stringWithFormat:@"\+%@", signInModel.money];
    }
    
    _timeLabel.text = signInModel.createTime;
    
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
