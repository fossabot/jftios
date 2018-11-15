//
//  SH_QuestionViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHHomeListModel.h"

static NSString * SH_QuestionViewCellId = @"SH_QuestionViewCellId";

@interface SH_QuestionViewCell : UITableViewCell


@property (nonatomic, strong) SHHomeListModel *listModel;

@end
