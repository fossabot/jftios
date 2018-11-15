//
//  SHBillListCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHBillListCell.h"
#import "SHMoneyModel.h"

@interface SHBillListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end


@implementation SHBillListCell


- (void)setModel:(SHMoneyModel *)model
{
    _model = model;
    
    _titleL.text = model.Description;
    _timeL.text = model.createTime;
    if ([model.trxType isEqualToString:@"expend"]) {
        _moneyL.text = [NSString stringWithFormat:@"\-%.2f", model.trxAmount];
        _moneyL.textColor = [UIColor blackColor];
    } else if ([model.trxType isEqualToString:@"join"]) {
        _moneyL.text = [NSString stringWithFormat:@"\+%.2f", model.trxAmount];
        _moneyL.textColor = navColor;
    }
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
