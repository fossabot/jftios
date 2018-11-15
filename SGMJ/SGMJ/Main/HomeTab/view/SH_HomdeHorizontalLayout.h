//
//  SH_HomdeHorizontalLayout.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/5.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_HomdeHorizontalLayout : UICollectionViewFlowLayout

//  一行中 cell 的个数
@property (nonatomic,assign) NSUInteger itemCountPerRow;

//一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;

@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;

@end
