//
//  SHHomeSearchVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/9/18.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHHomeSearchVController.h"
#import "SHRelCataModel.h"
#import "SHNoDataTableViewFooter.h"
#import "SHNeedTableViewCell.h"
#import "SHNeedTingModel.h"

#import "SHGoodDetailVController.h"
#import "SHSearchModel.h"
#import "SHHomeSearchCell.h"
#import "SHNeedDetailVController.h"


static NSString *identityCell = @"SHHomeSearchCell";
static NSString *identityNeedCell = @"SHNeedTableViewCell";
@interface SHHomeSearchVController () <UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;

@property (weak, nonatomic) IBOutlet UILabel *leftLineL;
@property (weak, nonatomic) IBOutlet UILabel *rightLineL;

@property (nonatomic, strong) UIButton *tmpButton;

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong) UITableView *serTableView;
@property (nonatomic, strong) UITableView *needTableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, strong) NSString *earliest;
@property (nonatomic, strong) NSString *latest;

@property (nonatomic, strong) NSString *needEarliest;
@property (nonatomic, strong) NSString *needLatest;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SHHomeSearchVController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initBaseInfo];
    //[self layout];
    
    [self loadDataWithType:SHInTheFirstTimeType andCurrent:@"0" andQuery:@"SERVER"];
    [self loadDataWithType:SHInTheFirstTimeType andCurrent:@"0" andQuery:@"NEED"];
}

- (void)initBaseInfo
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW -120, 40)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, titleView.width, titleView.height)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    
    searchBar.backgroundImage = [[UIImage alloc] init];
    [searchBar setImage:[UIImage imageNamed:@"search"]
       forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [titleView addSubview:searchBar];
    
    _searchBar = searchBar;
    
    //更改search圆角
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:SHColorFromHex(0xb7dbf7)];
        searchField.layer.cornerRadius = 20.0;
        searchField.layer.masksToBounds = YES;
        [searchField setValue:[UIFont boldSystemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];
        
    }
    self.navigationItem.titleView = titleView;
    
    for (UIButton *btn in _buttonArray) {
        if (btn.tag == 10) {
            _tmpButton = btn;
        }
    }
    
    _leftLineL.hidden = NO;
    _rightLineL.hidden = YES;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topView.frame) + 10, SHScreenW, SHScreenH - CGRectGetMaxY(self.topView.frame) - 10)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.contentSize = CGSizeMake(SHScreenW * 2, 0);
    [self.view addSubview:_scrollView];
    
    SHLog(@"%d", _scrollView.width)
    
    _serTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, _scrollView.height) style:UITableViewStylePlain];
    _serTableView.delegate = self;
    _serTableView.dataSource = self;
    [_serTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _serTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_serTableView];
    
    _needTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW, 0, SHScreenW, _scrollView.height) style:UITableViewStylePlain];
    _needTableView.delegate = self;
    _needTableView.dataSource = self;
    [_needTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _needTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_needTableView];
    
    SHWeakSelf
    _serTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithType:0 andCurrent:@"0" andQuery:@"SERVER"];
    }];
    _needTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithType:0 andCurrent:@"0" andQuery:@"NEED"];
    }];
    
}


- (IBAction)buttonsClick:(UIButton *)sender {
    
    if (sender == _tmpButton) {
        
    } else {
        [_tmpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:navColor forState:UIControlStateNormal];
        _tmpButton = sender;
        [UIView animateWithDuration:0.25 animations:^{
            _leftLineL.frame = CGRectMake(sender.centerX - 30, sender.height, 60, 1);
        }];
    }
    
}

- (void)loadDataWithType:(NSInteger)type andCurrent:(NSString *)current andQuery:(NSString *)queryType
{
    SHWeakSelf;
    NSDictionary *dic = @{
                          @"find":_searchBar.text ? _searchBar.text : @"",
                          @"queryType":queryType,
                          @"current":current,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHHomeSearchUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        
        if (code == 0) {
            if ([queryType isEqualToString:@"SERVER"]) {
                [self endRefreshWith:_serTableView];
                NSDictionary *pageDic = JSON[@"res"];
                self.earliest = pageDic[@"earliest"];
                self.latest = pageDic[@"latest"];
                NSArray *listArr = [SHSearchModel mj_objectArrayWithKeyValuesArray:pageDic[@"res"]];
                if (listArr.count < 10) {
                    if (type == 1 || type == 0) {
                        [weakSelf removeFooterWith:weakSelf.serTableView];
                    } else {
                        [_serTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                } else {
                    [weakSelf addFooterWith:weakSelf.serTableView];
                }
                
                if (type == 1 || type == 0) {
                    [self.dataSource removeAllObjects];
                }
                [self.dataSource addObjectsFromArray:listArr];
                [_serTableView reloadData];
                [weakSelf handleFooterWith:weakSelf.serTableView];
            } else if ([queryType isEqualToString:@"NEED"]) {
                [self endRefreshWith:_needTableView];
                NSDictionary *pageDic = JSON[@"res"];
                self.needEarliest = pageDic[@"earliest"];
                self.needLatest = pageDic[@"latest"];
                NSArray *listArr = [SHSearchModel mj_objectArrayWithKeyValuesArray:pageDic[@"res"]];
                if (listArr.count < 10) {
                    if (type == 1 || type == 0) {
                        [weakSelf removeFooterWith:weakSelf.needTableView];
                    } else {
                        [_needTableView.mj_footer endRefreshingWithNoMoreData];
                    }

                } else {
                    [weakSelf addFooterWith:_needTableView];
                }

                if (type == 1 || type == 0) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:listArr];
                SHLog(@"%@", self.dataArray)
                [_needTableView reloadData];
                [weakSelf handleFooterWith:_needTableView];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [self endRefreshWith:_serTableView];
        [self endRefreshWith:_needTableView];
    }];
    
    
    
}

//移除footer的处理
- (void)removeFooterWith:(UITableView *)tableView
{
    [tableView.mj_footer removeFromSuperview];
    tableView.mj_footer = nil;
}

//无数据的处理
- (void)handleFooterWith:(UITableView *)tableView
{
    if (self.dataSource.count == 0) {
        SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
        tableView.tableFooterView = footer;
    }
}

//footer的处理
- (void)addFooterWith:(UITableView *)tableView
{
    if (tableView.mj_footer) {
        return;
    }
    SHWeakSelf;
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
}

//结束刷新
- (void)endRefreshWith:(UITableView *)tableView
{
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    SHLog(@"%@", self.dataSource)
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _serTableView) {
        return self.dataSource.count;
    } else if (tableView == _needTableView) {
        return self.dataArray.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.serTableView) {
        SHHomeSearchCell *cellSer = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cellSer) {
            cellSer = [[SHHomeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        SHSearchModel *listModel = self.dataSource[indexPath.row];
        
        [cellSer setSearchModel:listModel];
        return cellSer;
    } else if (tableView == self.needTableView) {
        SHHomeSearchCell *cellNeed = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cellNeed) {
            cellNeed = [[SHHomeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        SHSearchModel *listModel = self.dataArray[indexPath.row];
        
        [cellNeed setSearchModel:listModel];
        return cellNeed;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (tableView == _serTableView) {
        SHGoodDetailVController *vc = [[SHGoodDetailVController alloc] init];
        SHSearchModel *listModel = self.dataSource[indexPath.row];
        vc.provideId = listModel.modelId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (tableView == _needTableView) {
        SHNeedDetailVController *vc = [[SHNeedDetailVController alloc] init];
        SHSearchModel *model = self.dataArray[indexPath.row];
        vc.needId = model.modelId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark - UISearchBar代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SHLog(@"%@", searchBar.text)
    [searchBar resignFirstResponder];
    [self loadDataWithType:SHInTheFirstTimeType andCurrent:@"0" andQuery:@"SERVER"];
    [self loadDataWithType:SHInTheFirstTimeType andCurrent:@"0" andQuery:@"NEED"];
}

#pragma mark - UIScrollViewDelegate协议代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        UIButton *btn = [self.topView viewWithTag:(scrollView.contentOffset.x/SHScreenW) + 10];
        SHLog(@"%d", btn.tag)
        
        [self buttonsClick:btn];
        
    }
}









@end
