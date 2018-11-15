//
//  SHSkillTViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHSkillModel;
@class SHMySkillModel;
@interface SHSkillTViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;



@property (nonatomic, strong) SHSkillModel *skillModel;


@property (nonatomic, strong) SHMySkillModel *myModel;

@end
