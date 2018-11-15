//
//  SH_HomeCategoryTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_HomeCategoryTableViewCell.h"
#import "SH_HomeCategoryViewCell.h"
#import "SH_HomdeHorizontalLayout.h"
#import "SDCycleScrollView.h"
#import "TAPageControl.h"
#import "SHHomeCatagoryModel.h"

static CGFloat itemH = 70;



@interface SH_HomeCategoryTableViewCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *categoryView;

@property (nonatomic, strong) SH_HomdeHorizontalLayout *layout;

@property (nonatomic, strong) TAPageControl *pageControl;


@end


@implementation SH_HomeCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}


- (void)initUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.categoryArr = [NSMutableArray array];
    [self.contentView addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.pageControl];
    [self.contentView bringSubviewToFront:self.pageControl];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SH_HomeCategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SH_HomeCategoryViewCellId forIndexPath:indexPath];
    
    SHHomeCatagoryModel *model = [self.categoryArr objectAtIndex:indexPath.row];
    cell.imageName = model.pic;
    cell.title = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHLog(@"技能分类collectionView 选中了cell  %ld -- ",indexPath.row);
    if (_clickBlock) {
        _clickBlock(indexPath.row);
    }
}

//减速结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX =  scrollView.contentOffset.x;
    
    NSInteger currentPage = offsetX / scrollView.bounds.size.width;
    
    [self.pageControl setCurrentPage:currentPage];
}


#pragma mark - setter

- (void)setCategoryArr:(NSMutableArray *)categoryArr {
    
    _categoryArr = categoryArr;
    int number = ceilf(categoryArr.count/10.f);
    
    self.pageControl.numberOfPages = number;
    [self.categoryView reloadData];
}

#pragma mark - lazy method

- (UICollectionView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _categoryView.backgroundColor = SH_WhiteColor;
        [_categoryView registerClass:[SH_HomeCategoryViewCell class] forCellWithReuseIdentifier:SH_HomeCategoryViewCellId];
        _categoryView.showsHorizontalScrollIndicator = NO;
        _categoryView.delegate = self;
        _categoryView.dataSource = self;
        _categoryView.pagingEnabled = YES;
    }
    return _categoryView;
}


- (SH_HomdeHorizontalLayout *)layout {
    if (!_layout) {
        _layout= [[SH_HomdeHorizontalLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(10, 0, 28, 0);
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(itemW, itemH);
        _layout.itemCountPerRow = 5;
        _layout.rowCount = 2;
    }
    return _layout;
}


- (TAPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[TAPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, SHScreenW*moduleRatio - 30 , SHScreenW, 20);
        _pageControl.numberOfPages = 3;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.dotImage = [UIImage imageNamed:@"bannerDotInActive"];
        _pageControl.currentDotImage = [UIImage imageNamed:@"bannerDot"];
        _pageControl.currentPage = 0;
        _pageControl.dotSize = CGSizeMake(15, 15);
    }
    return _pageControl;
}




@end
