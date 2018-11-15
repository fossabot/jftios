//
//  SHSystemMsgTViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSystemMsgTViewCell.h"

@interface SHSystemMsgTViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation SHSystemMsgTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
