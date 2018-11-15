//
//  SHSelectCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSelectCell.h"


@interface SHSelectCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end


@implementation SHSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
