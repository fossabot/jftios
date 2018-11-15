//
//  SH_HomeBannerTableViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSInteger num);

static NSString * SH_HomeBannerTableViewCellId = @"SH_HomeBannerTableViewCellId";

@interface SH_HomeBannerTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) SelectBlock selectBlock;

@end
