//
//  SH_HomeModuleTableViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//  四大板块的tableviewcell


#import <UIKit/UIKit.h>

static NSString * SH_HomeModuleTableViewCellId = @"SH_HomeModuleTableViewCell";

typedef void(^ModuleClickedBlock)(NSIndexPath *indexPath);

@interface SH_HomeModuleTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) ModuleClickedBlock clickBlock;

@end
