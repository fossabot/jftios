//
//  SHCityPickTViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCityPickTViewCell.h"
#import "SHCityPickCollectionView.h"

@interface SHCityPickTViewCell ()

@property (nonatomic, strong) SHCityPickCollectionView *cityCollectionView;

@end


@implementation SHCityPickTViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"id";
    SHCityPickTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SHCityPickTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.cityCollectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cityCollectionView.frame = self.bounds;
}

- (SHCityPickCollectionView *)cityCollectionView
{
    if (!_cityCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 20);
        _cityCollectionView = [[SHCityPickCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _cityCollectionView.scrollEnabled = YES;
        _cityCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _cityCollectionView;
}

- (void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    _cityCollectionView.dataArr = dataArr;
    [_cityCollectionView reloadData];
}










@end
