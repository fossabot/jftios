//
//  SHPaySelectView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPaySelectView.h"


static CGFloat const marginToLeft = 23.f;
static CGFloat const viewHeight = 76.f;
static CGFloat const imageHeight = 33.f;
static CGFloat const imageToLabel = 16.f;


@interface SHPaySelectView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UIView *lineView;         //分割线
@property (nonatomic, strong) UIView *lineViewTwo;      //第二个分割线
@property (nonatomic, strong) UIImageView *yueImgV;     //余额图像
@property (nonatomic, strong) UIImageView *zfbImgV;     //支付宝图像
@property (nonatomic, strong) UIImageView *wxImgV;      //微信图像
@property (nonatomic, strong) UIButton *yueButton;
@property (nonatomic, strong) UIButton *zfbButton;
@property (nonatomic, strong) UIButton *wxButton;
@property (nonatomic, strong) UILabel *yueLabel;
@property (nonatomic, strong) UILabel *zfbLabel;
@property (nonatomic, strong) UILabel *wxLabel;
@property (nonatomic, strong) UIImageView *zfbSelextImgV;
@property (nonatomic, strong) UIImageView *wxSelectImgV;
@property (nonatomic, strong) UIImageView *yueSelectImgV;

@property (nonatomic, strong) UIButton *tempButton;

@end

@implementation SHPaySelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [tap addTarget:self action:@selector(closeView)];
        [self addGestureRecognizer:tap];
        
        [self setupUI];
        
        [self addSubview:self.payView];
    }
    return self;
}


- (void)setupUI
{
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, self.payView.width, 0.5)];
    _lineView.backgroundColor = SHColorFromHex(0xedeaea);
    [self.payView addSubview:_lineView];
    
    _lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * viewHeight, self.payView.width, 0.5)];
    _lineViewTwo.backgroundColor = SHColorFromHex(0xedeaea);
    [self.payView addSubview:_lineViewTwo];
    
    _yueButton = [[UIButton alloc] init];
    _yueButton.tag = 3;
    [_yueButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.payView addSubview:_yueButton];
    [_yueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.payView.mas_top);
        make.left.mas_equalTo(self.payView.mas_left);
        make.right.mas_equalTo(self.payView.mas_right);
        make.height.mas_equalTo(viewHeight);
    }];
    
    _yueImgV = [[UIImageView alloc] init];
    _yueImgV.image = [UIImage imageNamed:@"yuezhifu"];
    [self.payView addSubview:_yueImgV];
    [_yueImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_yueButton.mas_centerY);
        make.left.equalTo(_yueButton.mas_left).offset(34);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(33);
    }];
    _yueLabel = [[UILabel alloc] init];
    _yueLabel.font = SH_FontSize(15);
    _yueLabel.text = @"余额支付";
    [self.payView addSubview:_yueLabel];
    [_yueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_yueButton.mas_centerY);
        make.left.equalTo(_yueImgV.mas_right).offset(16);
    }];
    _yueSelectImgV = [[UIImageView alloc] init];
    _yueSelectImgV.image = [UIImage imageNamed:@"paySelected"];
    [self.payView addSubview:_yueSelectImgV];
    [_yueSelectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payView.mas_right).offset(-22);
        make.centerY.equalTo(_yueButton.mas_centerY);
    }];
    
    //支付宝按钮
    _zfbButton = [[UIButton alloc] init];
    _zfbButton.tag = 1;
    //_tempButton = _zfbButton;
    [_zfbButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.payView addSubview:_zfbButton];
    [_zfbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(0);
        make.left.equalTo(self.payView.mas_left).offset(0);
        make.bottom.equalTo(_lineViewTwo.mas_top).offset(0);
        make.right.equalTo(self.payView.mas_right).offset(0);
    }];
    //支付宝头像
    _zfbImgV = [[UIImageView alloc] init];
    _zfbImgV.image = [UIImage imageNamed:@"zhifubaopay"];
    [self.payView addSubview:_zfbImgV];
    [_zfbImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zfbButton.mas_centerY);
        make.left.equalTo(_zfbButton.mas_left).offset(34);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(33);
    }];
    //支付宝label
    _zfbLabel = [[UILabel alloc] init];
    _zfbLabel.font =SH_FontSize(15);
    _zfbLabel.text = @"支付宝支付";
    [self.payView addSubview:_zfbLabel];
    [_zfbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zfbButton.mas_centerY);
        make.left.equalTo(_zfbImgV.mas_right).offset(16);
    }];
    //支付宝勾选图像
    _zfbSelextImgV = [[UIImageView alloc] init];
    _zfbSelextImgV.image = [UIImage imageNamed:@"payNoSelected"];
    [self.payView addSubview:_zfbSelextImgV];
    [_zfbSelextImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payView.mas_right).offset(-22);
        make.centerY.equalTo(_zfbButton.mas_centerY);
    }];
    
    //微信按钮
    _wxButton = [[UIButton alloc] init];
    _wxButton.tag = 2;
    [_wxButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.payView addSubview:_wxButton];
    [_wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineViewTwo.mas_bottom).offset(0);
        make.left.equalTo(self.payView.mas_left);
        make.right.equalTo(self.payView.mas_right);
        make.bottom.equalTo(self.payView.mas_bottom);
    }];
    //微信头像
    _wxImgV = [[UIImageView alloc] init];
    _wxImgV.image = [UIImage imageNamed:@"weixinpay"];
    [self.payView addSubview:_wxImgV];
    [_wxImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_wxButton.mas_centerY);
        make.left.equalTo(self.payView).offset(34);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(33);
    }];
    //微信label
    _wxLabel = [[UILabel alloc] init];
    _wxLabel.font = SH_FontSize(15);
    _wxLabel.text = @"微信支付";
    [self.payView addSubview:_wxLabel];
    [_wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_wxButton.mas_centerY);
        make.left.equalTo(_wxImgV.mas_right).offset(16);
    }];
    //微信勾选图像
    _wxSelectImgV = [[UIImageView alloc] init];
    _wxSelectImgV.image = [UIImage imageNamed:@"payNoSelected"];
    [self.payView addSubview:_wxSelectImgV];
    [_wxSelectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_wxButton.mas_centerY);
        make.right.equalTo(self.payView.mas_right).offset(-22);
    }];
    
}

/**
 *  点击
 */
- (void)payButtonClick:(UIButton *)button
{
    _tempButton = button;
    SHLog(@"%ld", (long)_tempButton.tag)
    if (button.tag == 1) {
        _zfbSelextImgV.image = [UIImage imageNamed:@"paySelected"];
        _wxSelectImgV.image = [UIImage imageNamed:@"payNoSelected"];
        _yueSelectImgV.image = [UIImage imageNamed:@"payNoSelected"];
        if (self.payBlock) {
            self.payBlock(kSH_PayUtilTypeAlipay);
        }
    } else if (button.tag == 2) {
        _zfbSelextImgV.image = [UIImage imageNamed:@"payNoSelected"];
        _wxSelectImgV.image = [UIImage imageNamed:@"paySelected"];
        _yueSelectImgV.image = [UIImage imageNamed:@"payNoSelected"];
        if (self.payBlock) {
            self.payBlock(kSH_PayUtilTypeWXPay);
        }
    } else if (button.tag == 3) {
        _zfbSelextImgV.image = [UIImage imageNamed:@"payNoSelected"];
        _wxSelectImgV.image = [UIImage imageNamed:@"payNoSelected"];
        _yueSelectImgV.image = [UIImage imageNamed:@"paySelected"];
        if (self.payBlock) {
            self.payBlock(kSH_PayUtilTypeYue);
        }
    }
    
    [self closeView];
    
}



/**
 *  展示view
 */
- (void)showView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        
    }];
    
}

/**
 *  关闭view
 */
- (void)closeView
{
    [UIView animateWithDuration:.3f delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
    } completion:^(BOOL finished) {
        [self.payView removeFromSuperview];
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
//    [UIView animateWithDuration:.3f animations:^{
//        [self.payView removeFromSuperview];
//        self.backgroundColor = [UIColor clearColor];
//        
//    } completion:^(BOOL finished) {
//        
//        [self removeFromSuperview];
//    }];
}


#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.payView]) {
        return NO;
    }
    return YES;
}

- (UIView *)payView
{
    if (_payView == nil) {
        _payView = [[UIView alloc] initWithFrame:CGRectMake(marginToLeft, self.centerY - viewHeight * 3 / 2, SHScreenW - 2 * marginToLeft, 3 * viewHeight)];
        _payView.backgroundColor = [UIColor whiteColor];
        _payView.layer.cornerRadius = 10;
        _payView.clipsToBounds = YES;
    }
    return _payView;
}





@end
