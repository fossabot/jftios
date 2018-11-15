//
//  SHSeleteAnswerCell.h
//  SGMJ
//
//  Created by 曾建国 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHAnswerItemModel;

@interface SHSeleteAnswerCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) NSString *questionStr;

@property (nonatomic, copy) NSString *questionAbcd;

@end
