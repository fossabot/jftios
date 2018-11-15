//
//  SHMessageView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchBlock)(void);
typedef void(^IndexBlock)(NSInteger row);

@interface SHMessageView : UIView <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) TouchBlock touchBlock;
@property (nonatomic, copy) IndexBlock indexBlock;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat layerHeight, layerWidth;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleSource, *imgSource;


- (id)initWithFrame:(CGRect)frame
          menuWidth:(CGFloat)width
             height:(CGFloat)height
              point:(CGPoint)point
              items:(NSArray *)items
          imgSource:(NSArray *)imgSource
             action:(void(^)(NSInteger index))action;






@end
