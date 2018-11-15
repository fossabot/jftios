//
//  SHRedPackageV.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHRedPackageTypeBlock)(NSString *buttonTitle);

@interface SHRedPackageV : UIView


@property (nonatomic, copy) SHRedPackageTypeBlock redPacBlock;

@property (nonatomic, strong) UILabel *moneyLabel;          //钱
@property (nonatomic, strong) UILabel *textLabel;           //
@property (nonatomic, strong) UILabel *contentLabel;        //描述
@property (nonatomic, strong) UIImageView *redImgView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *button;             //按钮文字


- (void)showRedPackageView;
- (void)closeRedPackageView;



@end
