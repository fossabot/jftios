//
//  SHAddressBookCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAddressBookCell.h"

@interface SHAddressBookCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviniteBtn;


@end


@implementation SHAddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


/**
 *  邀请用户下载家服通，如果已经是家服通用户，则显示已经是用户，否则显示邀请
 */
- (IBAction)invitateUserButtonClick:(UIButton *)sender {
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
