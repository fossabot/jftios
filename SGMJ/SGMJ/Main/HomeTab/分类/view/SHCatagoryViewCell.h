//
//  SHCatagoryViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/13.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHCatagoryListModel;


@protocol SHFollowAndCancelDelegate <NSObject>

- (void)followAndCancel;

@end

@interface SHCatagoryViewCell : UITableViewCell



@property (nonatomic, strong) SHCatagoryListModel *listModel;


@property (nonatomic, weak) id <SHFollowAndCancelDelegate> delegate;


@end
