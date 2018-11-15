//
//  SHMenuButtonView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHMenuButtonView;

/**
 *  协议
 */
@protocol SHMenuButtonViewDelegate <NSObject>
- (void)sh_menuButton:(SHMenuButtonView *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle;
@end

@interface SHMenuButtonView : UIView

/**
 *  列对应的数据源
 */
@property (nonatomic, strong) NSArray<NSArray *> *listTitles;
/**
 *  delegate
 */
@property (nonatomic, weak) id<SHMenuButtonViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame menuTitle:(NSArray *)menuTitles;




@end
