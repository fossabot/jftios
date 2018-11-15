//
//  SHPayPwdView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/13.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SHPayPwdBlock)(NSString *pwdString);

@interface SHPayPwdView : UIView


@property (nonatomic, copy) SHPayPwdBlock payBlock;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf4;
@property (nonatomic, strong) UITextField *tf5;
@property (nonatomic, strong) UITextField *tf6;

- (void)showPayPwdView;

- (void)closePayPwdView;

@end
