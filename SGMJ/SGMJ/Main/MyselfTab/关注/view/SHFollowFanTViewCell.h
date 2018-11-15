//
//  SHFollowFanTViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHFollowAndFansModel;

@protocol SHFollowAndFansDelegate <NSObject>

- (void)tellVCloadData;

@end


@interface SHFollowFanTViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, strong) SHFollowAndFansModel *model;

@property (nonatomic, weak) id<SHFollowAndFansDelegate>delegate;

@end
