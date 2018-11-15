//
//  SHNoDataTableViewFooter.m
//  SGMJ
//
//  Created by 曾建国 on 2018/8/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHNoDataTableViewFooter.h"

@implementation SHNoDataTableViewFooter

+ (instancetype)createWithTips:(NSString *)tips
{
    SHNoDataTableViewFooter *view = [[SHNoDataTableViewFooter alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 300)];
    view.backgroundColor = [UIColor clearColor];
//    UILabel *tipsLabel = [UILabel new];
//    [tipsLabel setFont:[UIFont systemFontOfSize:16]];
//    tipsLabel.textColor = [UIColor blackColor];
//    tipsLabel.numberOfLines = 0;
//    tipsLabel.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:tipsLabel];
//    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(view.mas_centerY);
//        make.left.right.mas_equalTo(view);
//    }];
//    tipsLabel.text = tips.length ? tips : @"暂无数据,刷新一下试试";
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"nodataImage"];
    [view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.centerX.mas_equalTo(view.mas_centerX);
//        make.left.right.mas_equalTo((SHScreenW - 100) / 2);
        make.height.mas_equalTo(132);
        make.width.mas_equalTo(194);
    }];
    
    
    return view;
}


@end
























