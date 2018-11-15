//
//  SHPerServiceCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPerServiceCell.h"
#import "SHRealeaseServiceModel.h"

@interface SHPerServiceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;



@end


@implementation SHPerServiceCell


- (void)setModel:(SHRealeaseServiceModel *)model
{
    _model = model;
    if (model.imageList[0]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imageList[0]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
    }
    
    _titleL.text = [NSString stringWithFormat:@"标题：%@", model.title];
    _priceL.text = [NSString stringWithFormat:@"%.2f\/%@", model.price, model.unit];
    
    
    
}







- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgView.layer.cornerRadius = _imgView.height / 2;
    _imgView.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
