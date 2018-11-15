//
//  SHScrollerViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/9/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHScrollerViewController.h"
#import "SHTabBarController.h"

//分页控件的高度
static const NSUInteger kPageControllerHeight = 20;
@interface SHScrollerViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *guideViewScrollView;    //引导页的滚动视图
@property (nonatomic, strong) UIPageControl *pageControl;           //创建分页控件 监控当前页面和使页面-页页的翻动
@property (nonatomic, copy) NSArray *imageNameArray;                //引导页图片的名字

@property (nonatomic, strong) UIButton *goToAppBtn;

@end

@implementation SHScrollerViewController

#pragma mark - lazying
- (UIScrollView *)guideViewScrollView
{
    if (!_guideViewScrollView) {
        _guideViewScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _guideViewScrollView.bounces = NO;
        _guideViewScrollView.showsHorizontalScrollIndicator = NO;
        //打开分页控件
        _guideViewScrollView.pagingEnabled = YES;
        _guideViewScrollView.delegate = self;
    }
    return _guideViewScrollView;
}

- (NSArray *)imageNameArray
{
    if (!_imageNameArray) {
        _imageNameArray = @[@"1", @"2", @"3"];
    }
    return _imageNameArray;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SHScreenH - 20, SHScreenW, 20)];
        _pageControl.currentPageIndicatorTintColor = navColor;
    }
    return _pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.guideViewScrollView];
    //[self.view addSubview:self.pageControl];
    [self initBaseInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"answerCorrect" object:nil];
}

- (void)initBaseInfo
{
    self.guideViewScrollView.contentSize = CGSizeMake(SHScreenW * self.imageNameArray.count, SHScreenH);
    //循环创建图片
    for (NSUInteger i = 0; i < self.imageNameArray.count; i++) {
        UIImage *image = [UIImage imageNamed:self.imageNameArray[i]];
        image = [self imageCompressWithSimple:image scaledToSize:CGSizeMake(SHScreenW, SHScreenH)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SHScreenW * i, 0, SHScreenW, SHScreenH)];
        imageView.image = image;
        [self.guideViewScrollView addSubview:imageView];
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = self.imageNameArray.count;
        
        if (i == self.imageNameArray.count - 1) {
            _goToAppBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * SHScreenW + 50, SHScreenH - 120, SHScreenW - 100, 44)];
            _goToAppBtn.layer.cornerRadius = 5;
            _goToAppBtn.layer.masksToBounds = YES;
            //_goToAppBtn.backgroundColor = [UIColor whiteColor];
            _goToAppBtn.borderWidth = 1.0;
            _goToAppBtn.borderColor = [UIColor whiteColor];
            [_goToAppBtn setTitle:@"进入应用" forState:UIControlStateNormal];
            _goToAppBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [_goToAppBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_goToAppBtn addTarget:self action:@selector(clickGoToButton) forControlEvents:UIControlEventTouchUpInside];
            [self.guideViewScrollView addSubview:_goToAppBtn];
        }
        
        
    }
    
}

// 缩放到指定大小
- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//进入应用
- (void)clickGoToButton
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SHTabBarController alloc] init];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.guideViewScrollView) {
        // 取到scrollView的偏移量好改变分页控件的currentPage
        CGFloat x = scrollView.contentOffset.x;
        // 根据偏移量四舍五入
        _pageControl.currentPage = lround(x / SHScreenW);
        
    }
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
