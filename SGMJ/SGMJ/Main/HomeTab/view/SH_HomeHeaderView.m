//
//  SH_HomeHeaderView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_HomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "SH_HomeCategoryViewCell.h"
#import "TAPageControl.h"
#import "UIView+SDExtension.h"
#import "SHHomeCatagoryModel.h"
//#import "SHHomeBannerModel.h"
#import "SH_HomdeHorizontalLayout.h"


static CGFloat itemH = 70;

@interface SH_HomeHeaderView ()<SDCycleScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UICollectionView *categoryView;

@property (nonatomic, strong) SH_HomdeHorizontalLayout *layout;

@property (nonatomic, strong) TAPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SH_HomeHeaderView
{
    CGRect _frame;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SHScreenW, SHScreenW*moduleRatio+178)];
    if (self) {
        
        _frame = CGRectMake(0, 0, SHScreenW, SHScreenW*moduleRatio+178);
        [self initUI];
    }
    return self;
}



- (void)initUI {
    
    
    [self addSubview:self.bannerView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.categoryView];
    [self addSubview:self.pageControl];
    
}



#pragma mark - private method


/**
 重新将数据源洗牌，变成多section的数据源，方便技能分类的分组展示

 @param arr 数据源
 */
- (void)resortModelArr:(NSMutableArray *)arr {
 
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *temp1 = [NSMutableArray array];
    
    for (SHHomeCatagoryModel *model in arr) {
        
        [temp addObject:model];
        if (temp.count % 10 == 0 && temp.count != 0 || [[arr lastObject] isEqual:model]) {
            
            [temp1 addObject:[temp mutableCopy]];
            [temp removeAllObjects];
        }
    }
    
    _categoryArr = temp1;
    
}


#pragma mark - setter

- (void)setBannerArr:(NSMutableArray *)bannerArr {
    
    _bannerArr = bannerArr;
    self.bannerView.imageURLStringsGroup = bannerArr;
}

- (void)setCategoryArr:(NSMutableArray *)categoryArr {
    
    _categoryArr = categoryArr;
    
//    [self resortModelArr:categoryArr];
}


#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (_categoryClickBlock) {
        _categoryClickBlock(HeaderViewClickedBanner,index);
    }
    SHLog(@"%s",__FUNCTION__);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
    [self.pageControl setCurrentPage:index];
}



#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    NSInteger fullNum = (NSInteger)self.categoryArr.count / 10.f;
//    if (section < fullNum) {
//        return 10;
//    }
//    return self.categoryArr.count % 10;
//    return 10;
//    NSArray *arr = self.categoryArr[section];
//    return arr.count;
    return self.categoryArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
//    CGFloat pages = self.categoryArr.count / 10.f;
//
//    if (pages > (NSInteger)pages) {
//        pages++;
//    }
//
//    return (NSInteger)pages;
    return 1;
//    return self.categoryArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == (self.categoryArr.count / 10)+1 && indexPath.row >= (self.categoryArr.count % 10)) {
//        return;
//    }
    if (_categoryClickBlock) {
        _categoryClickBlock(HeaderViewClickedCategory,indexPath.row);
    }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    CGSize size = CGSizeMake(itemW, itemH);
//    return size;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SH_HomeCategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SH_HomeCategoryViewCellId forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[SH_HomeCategoryViewCell alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
//    }
    
//    NSArray *sectionArr = self.categoryArr[indexPath.row];
    SHHomeCatagoryModel *model = self.categoryArr[indexPath.row];
//    SHLog(@"---第  %ld section  第  %ld row, name == %@",indexPath.section,indexPath.row, model.name)
    cell.title = model.name;
    cell.imageName = model.pic;
    
    return cell;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    _categoryView.ba_viewRectCornerType = BAKit_ViewRectCornerTypeTopLeftAndTopRight;
    _categoryView.ba_viewCornerRadius = 5;
}


#pragma mark - lazy method

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, SHScreenW*moduleRatio-10, SHScreenW, 188)];
        _backView.backgroundColor = SH_WhiteColor;
        _backView.layer.cornerRadius = 5.f;
        _backView.layer.masksToBounds = YES;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}


- (UICollectionView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[UICollectionView alloc] initWithFrame:self.backView.bounds collectionViewLayout:self.layout];
        _categoryView.backgroundColor = SH_WhiteColor;
        [_categoryView registerClass:[SH_HomeCategoryViewCell class] forCellWithReuseIdentifier:SH_HomeCategoryViewCellId];
        _categoryView.showsHorizontalScrollIndicator = NO;
        _categoryView.delegate = self;
        _categoryView.dataSource = self;
//        _categoryView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _categoryView.pagingEnabled = YES;
    }
    return _categoryView;
}


- (SH_HomdeHorizontalLayout *)layout {
    if (!_layout) {
        _layout= [[SH_HomdeHorizontalLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(10, contentMargin*2, 28, contentMargin*2);
//        _layout.minimumLineSpacing = (SHScreenW-60-(itemW*5))/4.f;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(itemW, itemH);
        _layout.itemCountPerRow = 5;
        _layout.rowCount = 2;
//        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SHScreenW, _frame.size.height - (SHScreenW*moduleRatio)) delegate:self placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        _bannerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, SHScreenW*moduleRatio)];
        _bannerView.delegate = self;
        _bannerView.currentPageDotImage = [UIImage imageNamed:@"bannerDot"];
        
        //设置图片视图显示类型
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        //滚动视图间隔
        _bannerView.autoScrollTimeInterval = 3.0;
        //设置轮播视图的分页控件的显示
        _bannerView.showPageControl = YES;
        //设置轮播图分页控件的位置
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _bannerView;
}


- (TAPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake((SHScreenW-200)/2, _frame.size.height - 30 , 200, 20)];
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _pageControl.currentDotImage = [UIImage imageNamed:@"bannerDot"];
        _pageControl.dotImage = [UIImage imageNamed:@"bannerDot"];
    }
    return _pageControl;
}


@end

