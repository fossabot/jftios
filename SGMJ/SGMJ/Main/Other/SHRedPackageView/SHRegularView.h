//
//  SHRegularView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHRegularView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textView;

- (void)showRegularView;
- (void)closeRegularView;




@end





