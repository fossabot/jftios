//
//  SH_AlertView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#define AlertView_W         HitoActureWidth(260.f)
#define SHATitle_H          20.0f
#define MessageMin_H        80.f        //messagelab的最小高度
#define SHABtn_H            35.0f

//屏幕宽度与高度
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

//比例宽和高（以6为除数）
#define HitoActureHeight(height)  roundf(height/375.0 * SCREEN_WIDTH)
#define HitoActureWidth(Width)  roundf(Width/667.0 * SCREENH_HEIGHT)

//字体
#define FONT_17 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:17.f] : [UIFont systemFontOfSize:13.5f]

#define FONT_15 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:15.f] : [UIFont systemFontOfSize:12.f]

//颜色
#define MAIN_COLOR ColorRGBA(118, 216, 206, 1)
#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

#import "SH_AlertView.h"
#import "UILabel+SH_WordSpace.h"

@interface SH_AlertView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *otherBtn;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation SH_AlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle
{
    self = [super init];
    
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        //title
        if (title) {
            self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, AlertView_W, SHATitle_H)];
            self.titleLab.text = title;
            self.titleLab.textAlignment = NSTextAlignmentCenter;
            self.titleLab.textColor = [UIColor blackColor];
            self.titleLab.font = FONT_17;
        }
        
        CGFloat messageLabSpace = 15;
        self.messageLab = [[UILabel alloc] init];
        self.messageLab.backgroundColor = [UIColor whiteColor];
        self.messageLab.text = message;
        self.messageLab.textColor = [UIColor lightGrayColor];
        self.messageLab.font = FONT_15;
        self.messageLab.numberOfLines = 0;
        self.messageLab.textAlignment = NSTextAlignmentCenter;
        self.messageLab.lineBreakMode = NSLineBreakByTruncatingTail;
        self.messageLab.characterSpace = 1;
        self.messageLab.lineSpace = 2;
        
        CGSize labSize = [self.messageLab getLableRectWithMaxWidth:AlertView_W - messageLabSpace * 2];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        self.messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+self.titleLab.frame.origin.y +10, AlertView_W-messageLabSpace*2, messageLabAotuH);
        self.textField = [[UITextField alloc] init];
        self.textField.frame = CGRectMake(messageLabSpace, _titleLab.frame.size.height+self.titleLab.frame.origin.y +10, AlertView_W-messageLabSpace*2, messageLabAotuH);
        
        //取消按钮文字
        if (cancelTitle) {
            self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            self.cancelBtn.titleLabel.font = FONT_15;
            self.cancelBtn.layer.cornerRadius = 3;
            self.cancelBtn.layer.masksToBounds = YES;
            self.cancelBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancelBtn];
        }
        
        if (otherBtnTitle) {
            self.otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
            self.otherBtn.titleLabel.font = FONT_15;
            self.otherBtn.layer.cornerRadius = 3;
            self.otherBtn.layer.masksToBounds = YES;
            self.otherBtn.backgroundColor = MAIN_COLOR;
            [self.otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.otherBtn];
        }
        
        CGFloat btn_y =  _titleLab.frame.size.height+10 + +self.titleLab.frame.origin.y + self.messageLab.frame.size.height +10;
        
        if (cancelTitle && !otherBtnTitle) {
            self.cancelBtn.tag=0;
            self.cancelBtn.frame =CGRectMake(15,btn_y, AlertView_W-30, SHABtn_H);
        }
        else if (!cancelTitle && otherBtnTitle)
        {
            self.otherBtn.tag=1;
            self.otherBtn.frame=CGRectMake(15,btn_y, AlertView_W-30, SHABtn_H);
        }
        else if (cancelTitle && otherBtnTitle)
        {
            _cancelBtn.tag=0;
            _otherBtn.tag=1;
            CGFloat btnSpace = 20;//两个btn之间的间距
            CGFloat btn_w =(AlertView_W-15*2-btnSpace)/2;
            _cancelBtn.frame=CGRectMake(15, btn_y, btn_w, SHABtn_H);
            _otherBtn.frame=CGRectMake(btn_w+15+20, btn_y, btn_w, SHABtn_H);
            
        }
        self.alertView.frame = CGRectMake(0, 0, AlertView_W, _titleLab.frame.size.height+10 + +self.titleLab.frame.origin.y + self.messageLab.frame.size.height +10 + SHABtn_H + 10);
        self.alertView.center = self.center;
        [self addSubview:self.alertView];
        
        
        [self.alertView addSubview:self.textField];
        [self.alertView addSubview:self.titleLab];
//        [self.alertView addSubview:self.messageLab];
    }
    
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shAlertView:clickedButtonAtIndex:)]) {
        [self.delegate shAlertView:self clickedButtonAtIndex:btn.tag];
    }
    [self dismissAlertView];
}

- (UIView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 5.0;
        _alertView.layer.masksToBounds = YES;
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}

-(void)show
{
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertView.transform = transform;
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}


#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.alertView]) {
        return NO;
    }
    return YES;
}






@end
