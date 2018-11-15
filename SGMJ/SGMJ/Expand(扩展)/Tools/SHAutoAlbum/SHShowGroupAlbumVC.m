//
//  SHShowGroupAlbumVC.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHShowGroupAlbumVC.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "SHShowAlbumVC.h"
#import "ALAssetsLibrary+SH.h"

@interface SHShowGroupAlbumVC () <UITableViewDelegate, UITableViewDataSource>
{
    ALAssetsLibrary *library;   //相册
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SHShowGroupAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self leftItemBackButton];
    
}

- (void)initBaseInfo {
    self.title = @"相 册";
    
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    //获得相册个数
    SHWeakSelf
    library = [[ALAssetsLibrary alloc] init];
    [library countOfAlbumGroup:^(ALAssetsGroup *shGroup) {
        [weakSelf.dataArray addObject:shGroup];
        [_tableView reloadData];
    }];
}

/**
 *  设置左边返回按钮
 */
- (void)leftItemBackButton {
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [returnBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    returnBtn.frame = CGRectMake(0, 0, 40, 30);
    
    [returnBtn addTarget:self action:@selector(clickReturnButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = itemBtn;
}
//返回按钮事件
- (void)clickReturnButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ALAssetsGroup *group = (ALAssetsGroup *)[_dataArray objectAtIndex:indexPath.row];
    if (group) {
        //相册最后一张图片
        cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
        //相册名字
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        if ([groupName isEqualToString:@"Camera Roll"]) {
            groupName = @"我的相册";
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)", groupName, (long)[group numberOfAssets]];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //跳转到照片页面
    SHShowAlbumVC *showVC = [[SHShowAlbumVC alloc] init];
    ALAssetsGroup *group = (ALAssetsGroup *)[_dataArray objectAtIndex:indexPath.row];
    showVC.group = group;
    showVC.listCount = self.listCount;
    showVC.color = self.albumColor;
    showVC.showStyle = self.showAlbumStyle;
    [self.navigationController pushViewController:showVC animated:YES];
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
