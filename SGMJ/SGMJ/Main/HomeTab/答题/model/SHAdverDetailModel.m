//
//  SHAdverDetailModel.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAdverDetailModel.h"

@implementation SHAdverDetailModel

- (void)setProfit:(NSString *)profit {
    
    CGFloat money = [profit floatValue];
    _profit = [NSString stringWithFormat:@"%.02f",money];
}

@end
