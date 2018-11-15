//
//  SHMenu.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMenu.h"
#import "SHMessageView.h"

@interface SHMenu ()

@property (nonatomic, strong) SHMessageView *menuView;

@end

@implementation SHMenu

+ (SHMenu *)shareManager
{
    static SHMenu *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[SHMenu alloc] init];
    });
    return menu;
}

- (void) showPopMenuSelecteWithFrameWidth:(CGFloat)width
                                   height:(CGFloat)height
                                    point:(CGPoint)point
                                     item:(NSArray *)item
                                imgSource:(NSArray *)imgSource
                                   action:(void (^)(NSInteger index))action{
    __weak __typeof(&*self)weakSelf = self;
    if (self.menuView != nil) {
        [weakSelf hideMenu];
    }
    UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
    self.menuView = [[SHMessageView alloc]initWithFrame:window.bounds
                                         menuWidth:width height:height point:point items:item imgSource:imgSource action:^(NSInteger index) {
                                             action(index);
                                             [weakSelf hideMenu];
                                         }];
    
    _menuView.touchBlock = ^{
        [weakSelf hideMenu];
    };
    
    self.menuView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [window addSubview:self.menuView];
    
    
    
}

- (void) hideMenu {
    [self.menuView removeFromSuperview];
    self.menuView = nil;
}



@end





