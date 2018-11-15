//
//  SHDownMenuListView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissBlock)(void);

@class SHMaskingView;

@interface SHDownMenuListView : UIView

/**
 *  蒙版
 */
@property (nonatomic, strong) SHMaskingView *maskingView;

/**
 *  回调
 */
@property (nonatomic, copy) DismissBlock dismissBlock;


@end
