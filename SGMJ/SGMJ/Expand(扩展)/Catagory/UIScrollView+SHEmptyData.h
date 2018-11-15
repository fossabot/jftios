//
//  UIScrollView+SHEmptyData.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

typedef void(^EmptyBlock)();

@interface UIScrollView (SHEmptyData)<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, copy) EmptyBlock emptyBlock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) CGFloat contentMargin;


- (void)setupEmptyDataTitle:(NSString *)title emptyImage:(NSString *)imageName contentMargin:(CGFloat)contentMargin finishClick:(EmptyBlock)finish;


/**
 快捷创建空数据占位 不用添加标题和图片

 @param finish 回调
 */
- (void)whenEmptyFinishClick:(EmptyBlock)finish;

@end
