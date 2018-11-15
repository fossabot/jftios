//
//  SHShowSelectCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHShowSelectCell.h"

@implementation SHShowSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)clickDeleteBtn:(UIButton *)sender {
    if (self.deletBlock) {
        self.deletBlock(sender.tag);
    }
}






@end
