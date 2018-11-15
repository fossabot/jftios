//
//  SHAddressSelectedCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAddressSelectedCell.h"
#import "SHBaiduAddressModel.h"

@interface SHAddressSelectedCell ()
@property (weak, nonatomic) IBOutlet UILabel *mainAddL;
@property (weak, nonatomic) IBOutlet UILabel *secondAddL;


@end


@implementation SHAddressSelectedCell


- (void)setModel:(SHBaiduAddressModel *)model
{
    _model = model;
    _mainAddL.text = model.deptName;
    _secondAddL.text = model.addr;
    _secondAddL.textColor = SHColorFromHex(0x9a9a9a);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
