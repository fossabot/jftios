//
//  UIScrollView+SHRefresh.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "UIScrollView+SHRefresh.h"
#import <MJRefresh/MJRefresh.h>

@implementation UIScrollView (SHRefresh)


- (void)setRefreshWithNormalHeaderBlock:(void (^)())headerBlock backNormalfooterBlock:(void (^)())footerBlock {
    
    if (headerBlock) {
        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            headerBlock();
        }];
    }
    
    
    if (footerBlock) {
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            footerBlock();
        }];
        
        [footer setTitle:@"--- 没有更多数据啦 ---" forState:MJRefreshStateNoMoreData];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        self.mj_footer = footer;
    }
}



- (void)headerBeginRefreshing {
    [self.mj_header beginRefreshing];
}

- (void)headerEndRefreshing {
    [self.mj_header endRefreshing];
}

- (void)footerBeginRefreshing {
    [self.mj_footer beginRefreshing];
}

- (void)footerEndRefreshing {
    [self.mj_footer endRefreshing];
}

- (void)footerNoMoreData {
    [self.mj_footer setState:MJRefreshStateNoMoreData];
}

- (void)hideFooterRefresh {
    self.mj_footer.hidden = YES;
}

- (void)hideHeaderRefresh {
    self.mj_header.hidden = YES;
}


@end
