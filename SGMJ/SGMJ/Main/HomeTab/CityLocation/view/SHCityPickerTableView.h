//
//  SHCityPickerTableView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBaseTableViewDelegate <NSObject>
- (void)tableView:(id)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SHCityPickerTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SHBaseTableViewDelegate> sd_delegate;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
