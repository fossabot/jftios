//
//  SH_HomeModuleCollectionViewCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
// 四大板块的collectionviewcell

#import <UIKit/UIKit.h>

static NSString *SH_HomeModuleCollectionViewCellId = @"SH_HomeModuleCollectionViewCellId";

@interface SH_HomeModuleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) UIImageView *image;

@end
