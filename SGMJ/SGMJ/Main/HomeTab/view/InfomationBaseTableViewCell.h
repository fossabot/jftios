//
//  InfomationBaseTableViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#define imgWidth ((SHScreenW-50)/3.f)
#define imgHratio (140/206.f)



@interface InfomationBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *time;

- (void)initUI;

@end
