//
//  SH_HomeCategoryTableViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#define itemW (SHScreenW/5.f)

#import <UIKit/UIKit.h>

static NSString * SH_HomeCategoryTableViewCellId = @"SH_HomeCategoryTableViewCellId";

typedef void(^CategoryClickedBlock)(NSInteger num);

@interface SH_HomeCategoryTableViewCell : UITableViewCell

@property (nonatomic, copy) CategoryClickedBlock clickBlock;
@property (nonatomic, strong) NSMutableArray *categoryArr;

@end
