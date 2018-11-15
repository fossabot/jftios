//
//  SHPayPwdView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/13.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPayPwdView.h"


#define ColorHUI [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0]

@interface SHPayPwdView () <UIGestureRecognizerDelegate>
{
    NSString *passwordStr;
}

@property (nonatomic, strong) UIView *tfView;
@property (nonatomic, strong) UIButton *closeButton;
//@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lineL;


@property (nonatomic, strong) UIView *keyBoardView;

@end

@implementation SHPayPwdView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [tap addTarget:self action:@selector(closePayPwdView)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        [self stepUI];
        
    }
    return self;
}


/**
 *  UI布局
 */
- (void)stepUI
{
    _tfView = [[UIView alloc] initWithFrame:CGRectMake(0, SHScreenH - 400, SHScreenW, 200)];
    _tfView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tfView];
    
    //关闭按钮
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(13, 13, 30, 30)];
    [_closeButton setImage:[UIImage imageNamed:@"centerClose"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closePayPwdView) forControlEvents:UIControlEventTouchUpInside];
    [_tfView addSubview:_closeButton];
    
    //title
    _titleLabel = [[UILabel alloc] init];
    [_tfView addSubview:_titleLabel];
    _titleLabel.text = @"请设置支付密码";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tfView.mas_centerX).offset(0);
        make.centerY.equalTo(_closeButton.mas_centerY).offset(0);
    }];
    
    //line
    _lineL = [[UILabel alloc] init];
    _lineL.backgroundColor = navColor;
    [_tfView addSubview:_lineL];
    [_lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tfView.mas_left).offset(0);
        make.top.equalTo(_closeButton.mas_bottom).offset(10);
        make.right.equalTo(_tfView.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    //六个tf
    _tf1 = [[UITextField alloc] initWithFrame:CGRectMake((_tfView.width - 300) / 2, 83, 50, 50)];
    _tf1.textAlignment = NSTextAlignmentCenter;
    _tf1.textColor = [UIColor blackColor];
    [_tf1 setSecureTextEntry:YES];
    _tf1.font = [UIFont systemFontOfSize:14.0f];
    _tf1.layer.borderWidth = 1;
    _tf1.layer.borderColor = [ColorHUI CGColor];
    [_tf1 setEnabled:NO];
    [_tfView addSubview:_tf1];
    
    _tf2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tf1.frame), CGRectGetMinY(_tf1.frame), 50, 50)];
    _tf2.textAlignment = NSTextAlignmentCenter;
    _tf2.textColor = [UIColor blackColor];
    [_tf2 setSecureTextEntry:YES];
    _tf2.font = [UIFont systemFontOfSize:14.0f];
    _tf2.layer.borderWidth = 1;
    _tf2.layer.borderColor = [ColorHUI CGColor];
    [_tf2 setEnabled:NO];
    [_tfView addSubview:_tf2];
    
    _tf3 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tf2.frame), CGRectGetMinY(_tf1.frame), 50, 50)];
    _tf3.textAlignment = NSTextAlignmentCenter;
    _tf3.textColor = [UIColor blackColor];
    [_tf3 setSecureTextEntry:YES];
    _tf3.font = [UIFont systemFontOfSize:14.0f];
    _tf3.layer.borderWidth = 1;
    _tf3.layer.borderColor = [ColorHUI CGColor];
    [_tf3 setEnabled:NO];
    [_tfView addSubview:_tf3];
    
    _tf4 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tf3.frame), CGRectGetMinY(_tf1.frame), 50, 50)];
    _tf4.textAlignment = NSTextAlignmentCenter;
    _tf4.textColor = [UIColor blackColor];
    [_tf4 setSecureTextEntry:YES];
    _tf4.font = [UIFont systemFontOfSize:14.0f];
    _tf4.layer.borderWidth = 1;
    _tf4.layer.borderColor = [ColorHUI CGColor];
    [_tf4 setEnabled:NO];
    [_tfView addSubview:_tf4];
    
    _tf5 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tf4.frame), CGRectGetMinY(_tf1.frame), 50, 50)];
    _tf5.textAlignment = NSTextAlignmentCenter;
    _tf5.textColor = [UIColor blackColor];
    [_tf5 setSecureTextEntry:YES];
    _tf5.font = [UIFont systemFontOfSize:14.0f];
    _tf5.layer.borderWidth = 1;
    _tf5.layer.borderColor = [ColorHUI CGColor];
    [_tf5 setEnabled:NO];
    [_tfView addSubview:_tf5];
    
    _tf6 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tf5.frame), CGRectGetMinY(_tf1.frame), 50, 50)];
    _tf6.textAlignment = NSTextAlignmentCenter;
    _tf6.textColor = [UIColor blackColor];
    [_tf6 setSecureTextEntry:YES];
    _tf6.font = [UIFont systemFontOfSize:14.0f];
    _tf6.layer.borderWidth = 1;
    _tf6.layer.borderColor = [ColorHUI CGColor];
    [_tf6 setEnabled:NO];
    [_tfView addSubview:_tf6];
    
    _tf1.text = @"";
    _tf2.text = @"";
    _tf3.text = @"";
    _tf4.text = @"";
    _tf5.text = @"";
    _tf6.text = @"";
    
    passwordStr = @"";
    
    //keyboardView
    _keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, SHScreenH - 200, SHScreenW, 200)];
    _keyBoardView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_keyBoardView];
    NSArray *array = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"", nil];
    for (int i = 0; i < array.count; i++) {
        NSInteger index = i%3;
        NSInteger page = i/3;
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index * (SHScreenW/3), page  * 50,SHScreenW/3,50);
        btn.tag=i;
        [btn setTitle:[array objectAtIndex:i] forState:normal];
        [btn setTitleColor:[UIColor blackColor] forState:normal];
        btn.layer.borderColor=[ColorHUI CGColor];
        btn.layer.borderWidth=0.5;
        
        
        if(i<=10)
        {
            if (i == 9) {
                btn.backgroundColor = SHColorFromHex(0xf2f2f2);
                btn.userInteractionEnabled = NO;
            }
            [btn addTarget:self action:@selector(KeyBoradClass:) forControlEvents:UIControlEventTouchUpInside];
        }
//        if(i==10)
//        {
//            [btn addTarget:self action:@selector(KeyBoradClear:) forControlEvents:UIControlEventTouchUpInside];
//
//        }
        if(i==11)
        {
            [btn setImage:[UIImage imageNamed:@"deletePassword"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(KeyBoradRemove:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [_keyBoardView addSubview:btn];
    }
    
    
}

#pragma 输入密码
-(void)KeyBoradClass:(UIButton *)btn
{
    NSArray * ary =[[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"x", nil];
    if (_tf1.text.length < 1) {
        if (_tf1.text.length == 0) {
            _tf1.text = [ary objectAtIndex:btn.tag];
        }
    }
    else if (_tf2.text.length < 1 && _tf1.text.length == 1) {
        if (_tf2.text.length == 0) {
            _tf2.text = [ary objectAtIndex:btn.tag];
        }
    }
    else if (_tf3.text.length < 1 && _tf2.text.length == 1) {
        if (_tf3.text.length == 0) {
            _tf3.text = [ary objectAtIndex:btn.tag];
        }
    }
    else if (_tf4.text.length < 1 && _tf3.text.length == 1) {
        if (_tf4.text.length == 0) {
            _tf4.text = [ary objectAtIndex:btn.tag];
        }
    }
    else if (_tf5.text.length < 1 && _tf4.text.length == 1) {
        if (_tf5.text.length == 0) {
            _tf5.text = [ary objectAtIndex:btn.tag];
        }
    }
    else if (_tf6.text.length < 1 && _tf5.text.length == 1) {
        if (_tf6.text.length == 0) {
            _tf6.text = [ary objectAtIndex:btn.tag];
        }
    }
    
#pragma mark 密码已有6位
    passwordStr = [NSString stringWithFormat:@"%@%@%@%@%@%@", _tf1.text, _tf2.text, _tf3.text, _tf4.text, _tf5.text, _tf6.text];
    if (passwordStr.length == 6) {
        SHLog(@"%@", passwordStr)
        if ([_titleLabel.text isEqualToString:@"请设置支付密码"]) {
            if (self.payBlock) {
                self.payBlock(passwordStr);
                
            }
            //通知发送设置密码的请求
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setPsdword" object:nil];
            
        } else if ([_titleLabel.text isEqualToString:@"请输入支付密码"]) {
            if (self.payBlock) {
                self.payBlock(passwordStr);
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payNoti" object:nil];
            //消失
            [self closePayPwdView];
        }
        
    }
    
}

#pragma mark 清空
-(void)KeyBoradClear:(UIButton *)btn{
    
    _tf1.text=@"";
    _tf2.text=@"";
    _tf3.text=@"";
    _tf4.text=@"";
    _tf5.text=@"";
    _tf6.text=@"";
    
}

#pragma mark 清除上一个
-(void)KeyBoradRemove:(UIButton *)btn
{
    if (passwordStr.length == 0) {
        _tf1.text=@"";
        _tf2.text=@"";
        _tf3.text=@"";
        _tf4.text=@"";
        _tf5.text=@"";
        _tf6.text=@"";
        return;
    }
    
    NSString *str = [passwordStr substringToIndex:passwordStr.length - 1];
    if (str.length == 6) {
        
    }
    else if (str.length == 5) {
        _tf6.text = @"";
    }
    else if (str.length == 4) {
        _tf5.text = @"";
        _tf6.text = @"";
    }
    else if (str.length == 3) {
        _tf4.text = @"";
        _tf5.text = @"";
        _tf6.text = @"";
    }
    else if (str.length == 2) {
        _tf3.text = @"";
        _tf4.text = @"";
        _tf5.text = @"";
        _tf6.text = @"";
    }
    else if (str.length == 1) {
        _tf2.text = @"";
        _tf3.text = @"";
        _tf4.text = @"";
        _tf5.text = @"";
        _tf6.text = @"";
    }
    else {
        _tf1.text = @"";
        _tf2.text = @"";
        _tf3.text = @"";
        _tf4.text = @"";
        _tf5.text = @"";
        _tf6.text = @"";
    }
    
    passwordStr = str;
    SHLog(@"%@", passwordStr)
    
}

/**
 *  显示支付view
 */
- (void)showPayPwdView
{
    _tf1.text = @"";
    _tf2.text = @"";
    _tf3.text = @"";
    _tf4.text = @"";
    _tf5.text = @"";
    _tf6.text = @"";
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    }];
}

/**
 *  隐藏支付view
 */
- (void)closePayPwdView
{
    [UIView animateWithDuration:.3f delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
    } completion:^(BOOL finished) {
        
        _tf1.text = @"";
        _tf2.text = @"";
        _tf3.text = @"";
        _tf4.text = @"";
        _tf5.text = @"";
        _tf6.text = @"";
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_tfView]) {
        return NO;
    }
    return YES;
}











@end
