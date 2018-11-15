//
//  SHStarRateView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/5.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SHStarRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, SHRateStyle) {
    SHWholeStar           =   0, //只能整星评论
    SHHalfStar           =   1,  //允许半星评论
    SHIncompleteStar    =   2    //允许不完整星评论
};

@protocol SHStarRateViewDelegate <NSObject>

- (void)starRateView:(SHStarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end


@interface SHStarRateView : UIView

@property (nonatomic, assign) BOOL isAnimation;     //是否动画显示，默认是NO
@property (nonatomic, assign) SHRateStyle rateStyle;//评分样式      默认是SHWholeStar
@property (nonatomic, weak) id<SHStarRateViewDelegate>delegate;

@property (nonatomic, assign) CGFloat currentScore;//当前评分0-5 默认0



- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(SHRateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;

- (instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numOfStars rateStyle:(SHRateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;
















@end
