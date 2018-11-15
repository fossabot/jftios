//
//  SHMaskingView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectRowBlock)(NSInteger row, NSString *rowTitle);

@interface SHMaskingView : UIView

/** 注释 */
@property (nonatomic, copy) SelectRowBlock selectRowBlock;

- (void)getDataSource:(NSArray *)arr menuIndex:(NSInteger)menuIndex;

- (void)reloadData;
- (void)dismiss;
- (void)show:(UIView *)superView;



@end
