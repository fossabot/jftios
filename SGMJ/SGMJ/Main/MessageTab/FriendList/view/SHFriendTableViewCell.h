//
//  SHFriendTableViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHFriendModel;
@interface SHFriendTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *introduceL;



@end
