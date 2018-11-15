//
//  SHStarRateView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/5.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHStarRateView.h"


#define ForegroundStarImage @"xingxing"
#define BackgroundStarImage @"xingempty"


typedef void(^completeBlock)(CGFloat currentScore);
@interface SHStarRateView ()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@property (nonatomic, assign) NSInteger numberOfStars;

@property (nonatomic, copy) completeBlock complete;

@end

@implementation SHStarRateView


#pragma mark - 代理方式
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = SHWholeStar;
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(SHRateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _delegate = delegate;
        [self createStarView];
    }
    return self;
}

#pragma mark - block方式
-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = SHWholeStar;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(SHRateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
    }
    return self;
}



#pragma mark - private Method
-(void)createStarView{
    
    self.foregroundStarView = [self createStarViewWithImage:ForegroundStarImage];
    self.backgroundStarView = [self createStarViewWithImage:BackgroundStarImage];
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentScore/self.numberOfStars, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
}


- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}


- (void)userTapRateView:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    switch (_rateStyle) {
        case SHWholeStar:
        {
            self.currentScore = ceil(realStarScore);
        }
            break;
        case SHHalfStar:
        {
            self.currentScore = roundf(realStarScore)>realStarScore ? ceilf(realStarScore):(ceilf(realStarScore)-0.5);
        }
            break;
        case SHIncompleteStar:
        {
            self.currentScore = realStarScore;
        }
            break;
            
        default:
            break;
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    SHWeakSelf
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.currentScore / self.numberOfStars, weakSelf.bounds.size.height);
    }];
}


- (void)setCurrentScore:(CGFloat)currentScore
{
    if (_currentScore == currentScore) {
        return;
    }
    
    if (currentScore < 0) {
        _currentScore = 0;
    } else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = currentScore;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:self currentScore:_currentScore];
    }
    
    if (self.complete) {
        _complete(_currentScore);
    }
    
    [self setNeedsLayout];
}





@end
