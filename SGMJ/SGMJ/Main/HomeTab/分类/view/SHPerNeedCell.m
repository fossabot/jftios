//
//  SHPerNeedCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPerNeedCell.h"
#import "SHPerNeedModel.h"



@interface SHPerNeedCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;


@end

@implementation SHPerNeedCell


- (void)setModel:(SHPerNeedModel *)model
{
    _model = model;
    
    _titleL.text = [NSString stringWithFormat:@"需求标题：%@", model.title];
    
    if (model.status == 0) {
        _statusL.text = @"状态：竞价中";
    } else if (model.status == 1) {
        _statusL.text = @"状态：服务进行中";
    } else if (model.status == 2) {
        _statusL.text = @"状态：已完成";
    } else if (model.status == 3) {
        _statusL.text = @"状态：退款";
    } else if (model.status == 4) {
        _statusL.text = @"状态：超时";
    } else if (model.status == 5) {
        _statusL.text = @"状态：弃标";
    }
    
    _priceL.text = [NSString stringWithFormat:@"%.2f元", model.money];
    
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
