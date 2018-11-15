//
//  SH_PictureScanView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_PictureScanView.h"

#define SHPictureCell @"PictureCell"

/**
 *  试图展示结构，基于collectionView
 */

@interface SH_PictureScanView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *dataArr1;

@end

@implementation SH_PictureScanView

//初始化 网络图片
- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgsArray withImgUrl:(NSArray *)imgUrlArray
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        _dataArr = [NSArray array];
        _dataArr1 = [NSArray array];
        
        _dataArr = imgUrlArray;
        _dataArr1 = imgsArray;
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:_flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:SHPictureCell];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
    }
    return self;
}

//这里可以粘贴图片上分享/保存等按钮 备用
- (void)createUI
{
    
}

/**
 *  CollectionView 代理
 */
#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArr1) {
        return self.dataArr1.count;
    }
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SHPictureCell forIndexPath:indexPath];
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    SHLog(@"%@", self.dataArr)
    [cell createUIWithImage:self.dataArr1[indexPath.item] ImgUrl:self.dataArr[indexPath.item] withIndex:indexPath.item];
    
    cell.myBlock = ^(NSString *gest) {
        if (_eventBlock) {
            _eventBlock(gest);
        }
        if ([gest isEqualToString:@"单击"]) {
            [self removeFromSuperview];
        }
    };
    
    return cell;
}


@end



/**
 *  图片处理部分（放大缩小移动）
 */
@interface PictureCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PictureCell

- (void)createUIWithImage:(UIImage *)image ImgUrl:(NSString *)imageUrl withIndex:(NSInteger)index
{
    if (imageUrl == nil && image == nil) {
        //避免都传空
        return;
    }
    
    UILabel *labe = [[UILabel alloc] init];
    labe.backgroundColor = [UIColor lightGrayColor];
    labe.frame = CGRectMake(SHScreenW / 2 - 30, 20, 60, 30);
    labe.text = [NSString stringWithFormat:@"%ld", index];
    labe.textColor = [UIColor darkTextColor];
    labe.layer.cornerRadius = labe.frame.size.height / 2;
    labe.layer.masksToBounds = YES;
    labe.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labe];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 3;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setContentOffset:CGPointMake(SHScreenW, 0)];
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    if (imageUrl == nil) {
        //本地图片
        self.imageView.image = image;
    }
    
    if (image == nil) {
        //网络图片，可设置其他加载图片，根据需求来
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
    [_scrollView addSubview:_imageView];
    
    
    //添加手势
    //一个手指
    UITapGestureRecognizer *singleClickDog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singliDogTap:)];
    UITapGestureRecognizer *doubleClickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    //两个手指
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTwoFingerTap:)];
    singleClickDog.numberOfTapsRequired = 1;
    singleClickDog.numberOfTouchesRequired = 1;
    doubleClickTap.numberOfTapsRequired = 2;//需要点两下
    twoFingerTap.numberOfTouchesRequired = 2;//需要两个手指touch
    [_imageView addGestureRecognizer:singleClickDog];
    [_imageView addGestureRecognizer:doubleClickTap];
    [_imageView addGestureRecognizer:twoFingerTap];
    [singleClickDog requireGestureRecognizerToFail:doubleClickTap];//如果双击了，则不响应单击事件
    [_scrollView setZoomScale:1];
    [self.contentView addSubview:_scrollView];
    
    
}

#pragma mark - ScrollView Delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
//缩放系数(倍数)
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}
#pragma mark - 事件处理
-(void)singliDogTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_myBlock) {
        _myBlock(@"单击");
    }
    if (gestureRecognizer.numberOfTapsRequired == 1)
    {
        
    }
}
-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (_myBlock) {
        _myBlock(@"双击");
    }
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if(_scrollView.zoomScale == 1){
            float newScale = [_scrollView zoomScale] *2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }else{
            float newScale = [_scrollView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

-(void)handelTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer{
    if (_myBlock) {
        _myBlock(@"2手指");
    }
    float newScale = [_scrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark - 缩放大小获取方法
-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [_scrollView frame].size.height/scale;
    zoomRect.size.width = [_scrollView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}
@end










