//
//  SHShowAlbumCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//


/**
 *  相册的选中效果cell
 */
#import "SHShowAlbumCell.h"

@implementation SHShowAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 *  按钮事件
 *  @param  sender sender description
 */
- (IBAction)clickBtn:(UIButton *)sender {
    if (!sender.selected) {
        if (self.selectedBlock) {
            self.selectedBlock(sender.tag);
        }
        //做一个小动画
        CABasicAnimation *anima = [CABasicAnimation animation];
        anima.keyPath = @"transform.scale";
        anima.toValue = @(1.3);
        anima.duration = 0.3;
        [sender.layer addAnimation:anima forKey:nil];
    } else {
        if (self.cancelBlock) {
            self.cancelBlock(sender.tag);
        }
    }
    sender.selected = !sender.selected;
}



@end


