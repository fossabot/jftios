//
//  SHCityPickerTableView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCityPickerTableView.h"
#import "SHCityModel.h"
#import "SHCityIntial.h"
#import "SHCityPickTViewCell.h"


@implementation SHCityPickerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.sectionIndexColor = navColor;
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
}

#pragma mark ----------UITabelViewDataSource----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2) {
        return 1;
    } else {
        SHCityIntial *cityInModel = self.dataArray[section];
        return cityInModel.cityArrs.count;
    }
}   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    SHCityPickTViewCell *cityCell = [SHCityPickTViewCell cellWithTableView:self];
    //配置数据
    //省
    SHCityIntial *cityInModel = self.dataArray[indexPath.section];
    if (cityInModel.cityArrs.count == 0) {
        return cityCell;
    } else {
        SHCityModel *cityModel = cityInModel.cityArrs[indexPath.row];
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
            cityCell.dataArr = [NSMutableArray arrayWithArray:cityInModel.cityArrs];
            cityCell.backgroundColor = [UIColor redColor];
            return cityCell;
        } else {
            cell.textLabel.text = cityModel.name;
            return cell;
        }
    }
    
}


#pragma mark ----------UITabelViewDelegate----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.sd_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.sd_delegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        SHCityIntial *cityInModel = self.dataArray[indexPath.section];
        CGFloat cellHeight = 0;
        if (cityInModel.cityArrs.count == 0) {
            //城市数据为0
            return cellHeight;
        } else {
            if (cityInModel.cityArrs.count % 3 == 0) {
                //城市数据为3的倍数
                cellHeight = cityInModel.cityArrs.count / 3 * 50;
            } else {
                cellHeight = (cityInModel.cityArrs.count / 3 + 1) * 50;
            }
            if (cellHeight > 300) {
                cellHeight = 300;
            }
            return cellHeight;
        }
    } else {
        return 50;
    }
}

/**
 *  索引值
 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //数组调用valueForKeyPath 返回一个SHCityInitial模型里的initial属性的值，放在一个数组中返回
    NSMutableArray *indexArrs = [NSMutableArray array];
    for (SHCityIntial *cityInModel in self.dataArray) {
        if (cityInModel.cityArrs.count > 0) {
            [indexArrs addObject:cityInModel.initial];
        }
    }
    return indexArrs;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SHCityIntial *cityInModel = self.dataArray[section];
    return (cityInModel.cityArrs.count) == 0 ? 0.1 : 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = [[UIView alloc] init];
    headview.frame = CGRectMake(0, 0, SHScreenW, 50);
    headview.backgroundColor = SHColorFromHex(0xf9f9f9);
    //标题
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(20, 15, SHScreenW, 20);
    headLabel.textColor = SHColorFromHex(0x404040);
    //赋值
    SHCityIntial *cityInModel = self.dataArray[section];
    headLabel.text = [NSString stringWithFormat:@"%@", cityInModel.initial];
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.font = [UIFont systemFontOfSize:15];
    headLabel.numberOfLines = 1;
    [headview addSubview:headLabel];
    
    if (cityInModel.cityArrs.count == 0) {
        return [[UIView alloc] init];
    }
    
    return headview;
}











@end




