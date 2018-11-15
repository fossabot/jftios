//
//  SHNeedTingModel.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHNeedTingModel.h"

@implementation SHNeedTingModel



- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        CGFloat margin = 10;
        //UIFont fontWithName:@"PingFangSC-Regular" size:12
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:12]};
        CGSize maxSize = CGSizeMake(SHScreenW - 26, MAXFLOAT);
        
        //计算文字占据的高度
        CGSize size = [self.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        
        //距顶16，头像40，16，标题20，描述size.height，10，20，10，20，10，10
        _cellHeight = size.height + 177;
        
    }
    return _cellHeight;
}








@end
