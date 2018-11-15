//
//  SHHomeSearchCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/9/18.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHHomeSearchCell.h"
#import "SHSearchModel.h"

@interface SHHomeSearchCell ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;


@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *goodImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;




@end

@implementation SHHomeSearchCell


- (void)setSearchModel:(SHSearchModel *)searchModel
{
    _searchModel = searchModel;
    SHLog(@"%@", searchModel.title)
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:searchModel.publishUserAvatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = searchModel.publishUserNickName;
    if ([searchModel.model isEqualToString:@"SERVER"]) {
        _leftContraint.constant = 80;
        _goodImgV.hidden = NO;
    } else if ([searchModel.model isEqualToString:@"NEED"]) {
        _leftContraint.constant = 13;
        _goodImgV.hidden = YES;
    }
    
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:searchModel.imageUrl] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    _titleL.text = searchModel.title;
    _contentL.text = [NSString stringWithFormat:@"描述:%@", searchModel.content];
    _moneyL.text = [NSString stringWithFormat:@"￥%.2f/%@", searchModel.price, searchModel.unit];
    
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
