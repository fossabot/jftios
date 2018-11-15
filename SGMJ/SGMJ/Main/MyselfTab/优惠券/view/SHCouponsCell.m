//
//  SHCouponsCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCouponsCell.h"

@interface SHCouponsCell()

@property (weak, nonatomic) IBOutlet UIImageView *couponsImgV;
@property (weak, nonatomic) IBOutlet UILabel *couponsMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UILabel *secondDetailL;
@property (weak, nonatomic) IBOutlet UILabel *useTimeL;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UIButton *useButton;




@end

@implementation SHCouponsCell




- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _useButton.layer.cornerRadius = _useButton.height / 2;
    _useButton.clipsToBounds = YES;
    _useButton.borderWidth = 1;
    _useButton.borderColor = navColor;
    [_useButton setTitleColor:navColor forState:UIControlStateNormal];
    
    _typeLabel.textColor = SH_WhiteColor;
    _typeLabel.backgroundColor = navColor;
    _typeLabel.cornerRadius = 2;
    _typeLabel.clipsToBounds = YES;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
