//
//  SHAddressSelectedCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHBaiduAddressModel;
@interface SHAddressSelectedCell : UITableViewCell



@property (nonatomic, strong) SHBaiduAddressModel *model;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;

@end
