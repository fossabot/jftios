
//
//  SH_CatagoryVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_CatagoryVController.h"
#import "SHMenuButtonView.h"
#import "SHSearchBar.h"
#import "SHGoodDetailVController.h"
#import "SHHomeCatagoryModel.h"
#import "SHCatagoryListModel.h"
#import "SHHeadFootView.h"
#import "SHCatagoryViewCell.h"
#import "SHNoDataTableViewFooter.h"
#import "SHRelCataModel.h"

static NSString *identityCell = @"SHCatagoryViewCell";
@interface SH_CatagoryVController () <SHMenuButtonViewDelegate, UITableViewDelegate, UITableViewDataSource, SHFollowAndCancelDelegate, UISearchBarDelegate>
@property (nonatomic, strong) SHMenuButtonView *btnView;
@property (nonatomic, strong) SHSearchBar *searchBarView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *heightArray;

@property (strong, nonatomic) IBOutlet UIView *titleV;


@property (nonatomic, copy) NSString *timeStamp;


@property (nonatomic, strong) NSString *earliest;
@property (nonatomic, strong) NSString *latest;

@property (nonatomic, strong) NSMutableArray *subArray;

@property (nonatomic, strong) NSArray *statusArray;

@property (nonatomic, copy) NSString *subId;
@property (nonatomic, copy) NSString *status;

@end

@implementation SH_CatagoryVController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //return
//    //SHColorFromHex(0x00a9f0)
//    //字体
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
//    
//    //导航栏背景色
//    self.navigationController.navigationBar.barTintColor = navColor;
//    
//    //修改返回按钮
//    UIButton * btn = [[UIButton alloc] init];
//    btn.frame = CGRectMake(0, 0, 30, 44);
//    UIImage * bImage = [[UIImage imageNamed: @"returnBack"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
//    [btn addTarget:self action:@selector(back) forControlEvents: UIControlEventTouchUpInside];
//    [btn setImage:bImage forState: UIControlStateNormal];
//    UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = - 20;
//    if (self.navigationController.viewControllers.count > 1) {
//        self.navigationItem.leftBarButtonItems = @[negativeSpacer, lb];
//    }
//    
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: navColor,NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
//    
//    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0x00a9f0);
//    
//}

- (NSMutableArray *)subArray
{
    if (!_subArray) {
        _subArray = [NSMutableArray array];
    }
    return _subArray;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    _subId = @"";
    _status = @"DEFAULT";
    _statusArray = @[@"DEFAULT", @"DISTANCE_ASC", @"DISTANCE_DESC", @"PRICE_ASC", @"PRICE_DESC", @"PRAISE_DESC"];
    
    
    [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:@"" withStatus:_status];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"loadServiceListData" object:nil];
    
    [self addInputTF];
    
    [self loadCatagoryData];
    
}

//分类数据-->筛选
- (void)loadCatagoryData
{
    SHWeakSelf;
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaServCatUrl params:nil success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%@", JSON)
        if (code == 0) {
            NSArray *array = [SHRelCataModel mj_objectArrayWithKeyValuesArray:JSON[@"categories"]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (SHRelCataModel *model in array) {
                NSMutableArray *secondArr = [NSMutableArray array];
                if ([model.name isEqualToString:_model.name]) {
                    //SHLog(@"%@", model.childList)
                    [weakSelf.subArray addObjectsFromArray:model.childList];
                    [weakSelf dealWithSelect];
                }
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//添加筛选
- (void)dealWithSelect
{
    _btnView = [[SHMenuButtonView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 40) menuTitle:@[@"筛选", @"排序"]];
    NSMutableArray *listOne = [NSMutableArray array];
    for (NSDictionary *dic in self.subArray) {
        [listOne addObject:dic[@"name"]];
    }
    //    NSArray *listArr1 = @[@"1", @"2",@"3"];
    NSArray *listArr2 = @[@"默认排序", @"距离从近到远",@"价格从低到高", @"价格从高到低", @"信誉从高到低"];
    _btnView.listTitles = @[listOne, listArr2];
    _btnView.delegate = self;
    
    [self.view addSubview:_btnView];
}

- (void)reloadData
{
    [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:@"" withStatus:@""];
}

- (void)initBaseInfo
{
    
    self.navigationItem.title = _model.name;
    
    _dataSource = [NSMutableArray array];
    _heightArray = [NSMutableArray array];
    [_tableView registerClass:[SHCatagoryViewCell class] forCellReuseIdentifier:identityCell];
    _tableView.estimatedRowHeight = 250;
    
    SHWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadListDataWithTimestamp:@"0" andType:0 withSubId:_subId withStatus:_status];
    }];
    
}

- (void)addInputTF
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
        [searchField setBackgroundColor:[UIColor colorWithRed:184.0/255.0 green:219.0/255.0 blue:246.0/255.0 alpha:1]];
        searchField.layer.cornerRadius = 20.0;
        searchField.layer.masksToBounds = YES;
        [searchField setValue:[UIFont boldSystemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];

    }
    self.navigationItem.titleView = titleView;
    
    
}


- (IBAction)loadAgainButtonClick:(UIButton *)sender {
    
    [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:@"" withStatus:@""];
    
}


//加载 筛选类型 对应的数据
- (void)loadListDataWithTimestamp:(NSString *)timestamp andType:(SHRefreshUpAndDownType)type withSubId:(NSString *)subId withStatus:(NSString *)status
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"current":timestamp,
                          @"type":@(type),
                          @"pageSize":@(10),
                          @"mainCat":@(_model.ID),
                          @"lon":@(SH_AppDelegate.personInfo.longitude),
                          @"lat":@(SH_AppDelegate.personInfo.latitude),
                          @"city":_city ? _city : @"",
                          @"subCat":subId,
                          @"find":_searchBar.text ? _searchBar.text : @"",
                          @"orderType":status ? status : @""
                          };
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHHomeServiceListUrl params:dic success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        //SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        self.tableView.hidden = NO;
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
        if (code == 0) {
            NSDictionary *pageDic = JSON[@"pageResult"];
            self.earliest = pageDic[@"earliest"];
            
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
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:listArr];
            [self.tableView reloadData];
            [self handleFooter];
        }
       
    } failure:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
}

//结束刷新
- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//footer的处理
- (void)addFooter
{
    if (self.tableView.mj_footer) {
        SHLog(@"存在")
        return;
    }
    
    SHWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
     
        [weakSelf loadListDataWithTimestamp:weakSelf.earliest andType:2 withSubId:_subId withStatus:_status];
    }];
    
}

//移除footer的处理
- (void)removeFooter
{
    [self.tableView.mj_footer removeFromSuperview];
    self.tableView.mj_footer = nil;
}

//无数据的处理
- (void)handleFooter
{
    if (self.dataSource.count == 0) {
        SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
        self.tableView.tableFooterView = footer;
    }
    else {
        [self removeFooter];
    }
}



#pragma mark - tableView DataSource
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHCatagoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHCatagoryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    cell.delegate = self;
    SHCatagoryListModel *listModel = _dataSource[indexPath.section];
    [cell setListModel:listModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SHGoodDetailVController *vc = [[SHGoodDetailVController alloc] init];
    SHCatagoryListModel *listModel = _dataSource[indexPath.section];
    vc.provideId = [listModel.serveSupply[@"id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - SHFollowAndCancelDelegate
- (void)followAndCancel
{
    if (_subId == 0) {
        [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:@"" withStatus:_status];
    } else {
        [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:_subId withStatus:_status];
    }
}

#pragma mark - SHMenuButtonViewDelegate
- (void)sh_menuButton:(SHMenuButtonView *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle
{
    if (index == 0) {
        for (NSDictionary *dic in self.subArray) {
            if ([dic[@"name"] isEqualToString:rowTitle]) {
                _subId = dic[@"id"];
                SHLog(@"%@", _subId)
                [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:_subId withStatus:_status];
            }
        }
        
    } else if (index == 1) {
        _status = _statusArray[row];
        [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:_subId withStatus:_statusArray[row]];
    }
    _btnView.title = rowTitle;
}

#pragma mark - UISearchBar代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SHLog(@"%@", searchBar.text)
    [searchBar resignFirstResponder];
    [self loadListDataWithTimestamp:@"0" andType:SHInTheFirstTimeType withSubId:_subId withStatus:_status];
}








@end
