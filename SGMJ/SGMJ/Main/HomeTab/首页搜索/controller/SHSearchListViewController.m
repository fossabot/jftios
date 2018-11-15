//
//  SHSearchListViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/9/18.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSearchListViewController.h"
#import "SHNoDataTableViewFooter.h"
#import "SHCatagoryViewCell.h"
#import "SHCatagoryListModel.h"

#import "SHNeedTableViewCell.h"
#import "SHNeedTingModel.h"

#import "SHGoodDetailVController.h"

static NSString *catagoryCell = @"SHCatagoryViewCell";
static NSString *identityNeedCell = @"SHNeedTableViewCell";
@interface SHSearchListViewController () <UITableViewDelegate, UITableViewDataSource, SHFollowAndCancelDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSString *earliest;
@property (nonatomic, strong) NSString *latest;

@end

@implementation SHSearchListViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.hidden = YES;
        if ([_status isEqualToString:@"SERVER"]) {
            [_tableView registerClass:[SHCatagoryViewCell class] forCellReuseIdentifier:catagoryCell];
        } else if ([_status isEqualToString:@"NEED"]) {
            [_tableView registerClass:[SHNeedTableViewCell class] forCellReuseIdentifier:identityNeedCell];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layout];
    
    [self loadDataWithType:SHInTheFirstTimeType andCurredt:@"0"];
    
}

#pragma mark - layout
- (void)layout
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    SHWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithType:SHInTheFirstTimeType andCurredt:@"0"];
    }];
}

- (void)loadDataWithType:(NSInteger)type andCurredt:(NSString *)current
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"find":_searchString ? _searchString : @"",
                          @"queryType":_status,
                          @"current":current,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    SHLog(@"%@", dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHHomeSearchUrl params:dic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.tableView.hidden = NO;
        [weakSelf endRefresh];
        if (code == 0) {
            if ([_status isEqualToString:@"SERVER"]) {
                NSDictionary *pageDic = JSON[@"pageResult"];
                self.earliest = dic[@"earliest"];
                self.latest = dic[@"latest"];
                NSArray *listArr = [SHCatagoryListModel mj_objectArrayWithKeyValuesArray:pageDic[@"res"]];
                if (listArr.count < 10) {
                    if (type == 1 || type == 0) {
                        [self removeFooter];
                    } else {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                }
                //            else {
                //                [self addFooter];
                //            }
                
                if (type == 1 || type == 0) {
                    [self.dataArr removeAllObjects];
                }
                [self.dataArr addObjectsFromArray:listArr];
                [self.tableView reloadData];
                [self handleFooter];
            } else if ([_status isEqualToString:@"NEED"]) {
                
            }
        }
        
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [weakSelf handleFooter];
    }];
}

//结束刷新
- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//无数据处理
- (void)handleFooter
{
    if (self.dataArr.count == 0) {
        SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
        self.tableView.tableFooterView = footer;
    }
}

//移除footer的处理
- (void)removeFooter
{
    [self.tableView.mj_footer removeFromSuperview];
    self.tableView.mj_footer = nil;
}

//添加footer
- (void)addFooter
{
    if (self.tableView.mj_footer) {
        return;
    }
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellOne = [[UITableViewCell alloc] init];
    if ([_status isEqualToString:@"SERVER"]) {
        SHCatagoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:catagoryCell];
        if (!cell) {
            cell = [[SHCatagoryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:catagoryCell];
        }
        cell.delegate = self;
        SHCatagoryListModel *listModel = self.dataArr[indexPath.section];
        [cell setListModel:listModel];
        cellOne = cell;
    } else if ([_status isEqualToString:@"NEED"]) {
        
    }
    
    return cellOne;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHGoodDetailVController *vc = [[SHGoodDetailVController alloc] init];
    SHCatagoryListModel *listModel = self.dataArr[indexPath.section];
    vc.provideId = [listModel.serveSupply[@"id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - SHFollowAndCancelDelegate
- (void)followAndCancel
{
    [self loadDataWithType:SHInTheFirstTimeType andCurredt:0];
}




@end
