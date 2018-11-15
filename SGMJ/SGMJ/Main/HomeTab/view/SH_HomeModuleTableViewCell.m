//
//  SH_HomeModuleTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_HomeModuleTableViewCell.h"
#import "SHHomeModuleIteModel.h"
#import "SH_HomeModuleCollectionViewCell.h"
#import "SH_HomdeHorizontalLayout.h"


#define Header @"HeaderView"
#define Footer @"FooterView"

@interface SH_HomeModuleTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SH_HomdeHorizontalLayout *layout;

@end

@implementation SH_HomeModuleTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    SHLog(@"layoutsubviews方法调用 四大板块的cell高度  %@",NSStringFromCGRect(self.frame));
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_clickBlock) {
        _clickBlock(indexPath);
    }
}

//头部 尾部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reuseView = nil;
    
    if (UICollectionElementKindSectionHeader == kind) {
        
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header forIndexPath:indexPath];
        reuseView.backgroundColor = SH_WhiteColor;
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, SHScreenW/2)];
//        view.backgroundColor = [UIColor yellowColor];
//        [headerView addSubview:view];
    }else {
        
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Footer forIndexPath:indexPath];
        reuseView.backgroundColor = SH_WhiteColor;
    }
    return reuseView;
}

//设置headerView大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(10, SHScreenW/2);
}


- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section {
    return SH_GroupBackgroundColor;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SH_HomeModuleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SH_HomeModuleCollectionViewCellId forIndexPath:indexPath];
    
    SHHomeModuleIteModel *model = self.dataSource[indexPath.row];
    
    cell.title.text = model.title;
    cell.subtitle.text = model.subtitle;
    cell.image.image = [UIImage imageNamed:model.image];
    
    return cell;
}





#pragma mark - lazy method

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        SHHomeModuleIteModel *model1 = [[SHHomeModuleIteModel alloc] init];
        model1.title = @"求职招聘";
        model1.subtitle = @"找工作称心如意";
        model1.image = @"home_employee";
        
        SHHomeModuleIteModel *model2 = [[SHHomeModuleIteModel alloc] init];
        model2.title = @"房屋租赁";
        model2.subtitle = @"出租更省心";
        model2.image = @"home_rent";
        
        SHHomeModuleIteModel *model3 = [[SHHomeModuleIteModel alloc] init];
        model3.title = @"招标信息";
        model3.subtitle = @"安全专业的平台";
        model3.image = @"home_bidding";
        
        SHHomeModuleIteModel *model4 = [[SHHomeModuleIteModel alloc] init];
        model4.title = @"微公益";
        model4.subtitle = @"出租更省心";
        model4.image = @"home_publicBenefit";
        
        SHHomeModuleIteModel *model5 = [[SHHomeModuleIteModel alloc] init];
        model5.title = @"求职招聘";
        model5.subtitle = @"找工作称心如意";
        model5.image = @"cai_1";
        
        SHHomeModuleIteModel *model6 = [[SHHomeModuleIteModel alloc] init];
        model6.title = @"房屋租赁";
        model6.subtitle = @"出租更省心";
        model6.image = @"cai_2";
        
        SHHomeModuleIteModel *model7 = [[SHHomeModuleIteModel alloc] init];
        model7.title = @"招标信息";
        model7.subtitle = @"安全专业的平台";
        model7.image = @"cai_3";
        
        SHHomeModuleIteModel *model8 = [[SHHomeModuleIteModel alloc] init];
        model8.title = @"微公益";
        model8.subtitle = @"出租更省心";
        model8.image = @"cai_4";
        
        [_dataSource addObject:model1];
        [_dataSource addObject:model2];
        [_dataSource addObject:model3];
        [_dataSource addObject:model4];
        
        [_dataSource addObject:model5];
        [_dataSource addObject:model6];
        [_dataSource addObject:model7];
        [_dataSource addObject:model8];
        
    }
    return _dataSource;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
//        [_collectionView setCollectionViewLayout:self.layout];
        _collectionView.backgroundColor = SH_WhiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SH_HomeModuleCollectionViewCell class] forCellWithReuseIdentifier:SH_HomeModuleCollectionViewCellId];
//        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = SH_GroupBackgroundColor;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Header];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Footer];
    }
    return _collectionView;
}

- (SH_HomdeHorizontalLayout *)layout {
    if (!_layout) {
        _layout= [[SH_HomdeHorizontalLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(0, contentMargin, 0, contentMargin);
        _layout.headerSize = CGSizeMake(10, SHScreenW);
        _layout.footerSize = CGSizeMake(10, SHScreenW);
        _layout.minimumLineSpacing = 1;
        _layout.minimumInteritemSpacing = 1;
        _layout.itemSize = CGSizeMake((SHScreenW-20-1)/2, SHScreenW/4-0.5);
        _layout.rowCount = 2;
        _layout.itemCountPerRow = 2;
        
    }
    return _layout;
}

@end
