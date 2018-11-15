//
//  SHCityPickTViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCityPickTViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end
