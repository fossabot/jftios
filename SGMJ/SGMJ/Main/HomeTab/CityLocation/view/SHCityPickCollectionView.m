//
//  SHCityPickCollectionView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCityPickCollectionView.h"
#import "SHCityModel.h"

#define SHCityPickerCellID @"SHCityPickerCellID"

@interface SHCityPickCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end


@implementation SHCityPickCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        //注册
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SHCityPickerCellID];
    }
    return self;
}

#pragma mark ----------UICollectionViewDelegate----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SHCityPickerCellID forIndexPath:indexPath];
    //配置数据
    SHCityModel *cityModel = self.dataArr[indexPath.row];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@", cityModel.name];
    label.frame = CGRectMake(0, 10, (SHScreenW - 80) / 3, 32);
    label.font = [UIFont systemFontOfSize:15];
    label.layer.cornerRadius = 4.0;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = SHColorFromHex(0x3f3f3f);
    label.backgroundColor = [UIColor whiteColor];
    label.borderWidth = 0.5;
    label.borderColor = SHColorFromHex(0x9a9a9a);
    [cell.contentView addSubview:label];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHCityModel *cityModel = self.dataArr[indexPath.row];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[SDCityDidSelectKey] = cityModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:SDCityDidSelectedNotification object:nil userInfo:userInfo];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SHScreenW - 80) / 3, 32);
}

















@end
