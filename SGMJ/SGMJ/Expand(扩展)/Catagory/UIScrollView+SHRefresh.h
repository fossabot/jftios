//
//  UIScrollView+SHRefresh.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (SHRefresh)

//设置刷新即加载更多
- (void)setRefreshWithNormalHeaderBlock:(void (^)())headerBlock
                  backNormalfooterBlock:(void (^)())footerBlock;


//调用此方法刷新
- (void)headerBeginRefreshing;

//调用此方法停止刷新
- (void)headerEndRefreshing;

//调用此方法加载更多
- (void)footerBeginRefreshing;

//调用此方法停止加载更多
- (void)footerEndRefreshing;

//显示没有更多数据
- (void)footerNoMoreData;

//隐藏头部视图
- (void)hideHeaderRefresh;

//隐藏尾部视图
- (void)hideFooterRefresh;

@end
