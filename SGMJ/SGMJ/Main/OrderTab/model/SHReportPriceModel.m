//
//  SHReportPriceModel.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/13.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHReportPriceModel.h"

@implementation SHReportPriceModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}


- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        //UIFont fontWithName:@"PingFangSC-Regular" size:12
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
        CGSize maxSize = CGSizeMake(SHScreenW - 26, MAXFLOAT);
        
        //计算文字占据的高度
        CGSize size = [self.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        _cellHeight = 170 + size.height + 10;
    }
    return _cellHeight;
}


@end
