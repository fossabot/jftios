//
//  SHOrderListCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/1.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHOrderListModel;

@protocol SHOrderStatusChangeDelegate <NSObject>

- (void)changeOrderStatus:(SHOrderChangeStatusType)status;
@end

@interface SHOrderListCell : UITableViewCell


@property (nonatomic, strong) SHOrderListModel *listModel;

@property (nonatomic, weak) id<SHOrderStatusChangeDelegate>delegate;


@end
