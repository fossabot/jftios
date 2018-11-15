//
//  SHServiceDetailHeadView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHCatagoryListModel;

@protocol SHCancelFollowDelegate <NSObject>

- (void)clickFollowButton;

@end

@interface SHServiceDetailHeadView : UIView


@property (nonatomic, strong) SHCatagoryListModel *commentModel;

@property (nonatomic, weak) id <SHCancelFollowDelegate> delegate;

@end
