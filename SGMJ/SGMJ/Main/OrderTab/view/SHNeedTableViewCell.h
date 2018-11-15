//
//  SHNeedTableViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHNeedTingModel;


@interface SHNeedTableViewCell : UITableViewCell


@property (nonatomic, strong) SHNeedTingModel *model;


- (void)createMainViewCellWithSHNeedTingModel:(SHNeedTingModel *)model;
+ (CGFloat)cellHeightWithModel:(SHNeedTingModel *)model;

@end
