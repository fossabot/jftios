//
//  SHTabBar.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHTabBar.h"
#import "UIImage+Image.h"

@interface SHTabBar()
/**
 *  plus按钮
 */

@property (nonatomic, weak) UIButton *plusBtn;

@property (nonatomic, strong) UILabel *label;

@end

@implementation SHTabBar

+ (void)initialize
{
    if (self == [SHTabBar class]) {
        
        NSDictionary *attrNormal = @{
                                     NSFontAttributeName : [UIFont systemFontOfSize:12]
                                     };
        NSDictionary *attrSelected = @{
                                       NSFontAttributeName : [UIFont systemFontOfSize:12]
                                       };
        
        [[UITabBarItem appearance] setTitleTextAttributes:attrNormal forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:attrSelected forState:UIControlStateNormal];
    }
}

//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index
{
    //移除之前的小红点
    [self removeBadageOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5.0;//圆形
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / 5;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10.0, 10.0);
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
        
}

- (void)hideBadgeOnItemIndex:(NSInteger)index
{
    //移除小红点
    [self removeBadageOnItemIndex:index];
}

- (void)removeBadageOnItemIndex:(NSInteger)index
{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
        
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_release"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_release"] forState:UIControlStateHighlighted];

        self.plusBtn = plusBtn;
        SHLog(@"tabbar自定义")
        [plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
    }
    return self;
}


- (void)removeLine:(UIView *)view {
    
    if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height < 1.f) {
        
        [view removeFromSuperview];
    }
    
    if (view.subviews.count == 0) return;
    
    for (UIView *subView in view.subviews) {
        [self removeLine:subView];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self removeLine:self];
    
    //系统自带的按钮类型是UITabBarButton,找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    CGRect frame = self.plusBtn.frame;
    frame.origin.x = (SHScreenW/2)-25;
    //调整发布按钮的中心点Y的值self.height * 0.5 - 2 * SHMarginToEdge
    frame.origin.y = -25;
//    self.plusBtn.size = CGSizeMake(self.plusBtn.currentBackgroundImage.size.width, self.plusBtn.currentBackgroundImage.size.height);
    frame.size = CGSizeMake(50, 50);
    self.plusBtn.frame = frame;
    
    if (!_label) {
        SHLog(@"发布label")
        _label = [[UILabel alloc] init];
        _label.text = @"发布";
        _label.font = [UIFont systemFontOfSize:12];
        [_label sizeToFit];
        _label.textColor = [UIColor grayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        CGRect labelFrame = _label.frame;
        labelFrame.origin.x = frame.origin.x;
        labelFrame.origin.y = 49 - 15;
        labelFrame.size.width = 50;

        _label.frame = labelFrame;
        [self addSubview:_label];
        
    }
    
    int btnIndex = 0;
    //便利tabbar的子控件
    for (UIView *btn in self.subviews) {
        //如果是系统的UITabBarButton，那么就调整子控件的位置，空出中间位置
        if ([btn isKindOfClass:class]) {
            //每一个按钮的宽度==tabbar的五分之一
            btn.width = self.width / 5;
            btn.x = btn.width * btnIndex;
            btnIndex++;
            //如果是索引为2（从0开始的），直接让索引++，目的是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
            }
        }
    }
    
    [self bringSubviewToFront:self.plusBtn];
    
    UIImage *image = [UIImage imageWithColor:SH_RGBA(230, 230, 230, 0.4)];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.frame = CGRectMake(0, -2, SHScreenW, 2);
    [self addSubview:imageView];
    [self insertSubview:imageView belowSubview:self.plusBtn];
}

//点击了发布按钮
- (void)plusBtnDidClick {
    //如果tabbar的代理实现了对应的代理方法，那么就调用代理的该方法
    if ([self.delegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.myDelegate tabBarPlusBtnClick:self];
    }
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让突出的部分点击有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //这一个判断是关键，不判断的话，push到其他页面，点击发布的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面室友tabbat的，那么肯定是在导航控制器的根控制页面
    //在导航控制器根控制器页面，那么我们就需要判断数值点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理时间，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        //将当前tabbat的触摸点转换成坐标，转移到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.plusBtn];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ([self.plusBtn pointInside:newP withEvent:event]) {
            return self.plusBtn;
        } else {
            //如果点不在发布按钮身上，直接让系统处理
            return [super hitTest:point withEvent:event];
        }
    } else {
        //tababr隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
    
    
}


@end
