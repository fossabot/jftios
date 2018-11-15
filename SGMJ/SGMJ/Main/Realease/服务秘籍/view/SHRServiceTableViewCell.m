//
//  SHRServiceTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/11.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHRServiceTableViewCell.h"

@interface SHRServiceTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeL;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameL;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end


@implementation SHRServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headImgV.layer.cornerRadius = _headImgV.height / 2;
    _headImgV.clipsToBounds = YES;
    _serviceNameL.textColor = SHColorFromHex(0x9a9a9a);
    _descriptionL.textColor = SHColorFromHex(0x9a9a9a);
    
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
