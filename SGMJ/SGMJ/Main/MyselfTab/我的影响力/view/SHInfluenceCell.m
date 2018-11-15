//
//  SHInfluenceCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHInfluenceCell.h"
#import "SHTeamModel.h"

@interface SHInfluenceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *totalNumL;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIView *cellView;


@end

@implementation SHInfluenceCell


- (void)setModel:(SHTeamModel *)model
{
    _model = model;
    
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _timeL.text = [NSString stringWithFormat:@"%@加入家服通", model.joinTime];
    _totalNumL.text = [NSString stringWithFormat:@"(团队%d人)", model.totalNum];
    _totalMoneyL.text = [NSString stringWithFormat:@"(总收益%.2f元)", model.totalMoney];
    
    
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    _cellView.layer.cornerRadius = 10;
    _cellView.clipsToBounds = YES;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
