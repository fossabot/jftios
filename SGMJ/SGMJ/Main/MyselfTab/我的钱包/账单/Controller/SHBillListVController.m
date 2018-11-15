//
//  SHBillListVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHBillListVController.h"

#import "SHBillListCell.h"
#import "SHBillDetailViewController.h"
#import "SHMoneyModel.h"
#import "SHNoDataTableViewFooter.h"
#import "SHMyRedPackageModel.h"

#import "SHOrderLisrChildViewController.h"
#import "CCZSegementController.h"

static NSString *identityCell = @"SHBillListCell";
@interface SHBillListVController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *walletBtn;
@property (weak, nonatomic) IBOutlet UIButton *redMoneyBtn;

@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (nonatomic, strong) UIButton *tempBtn;

@property (nonatomic, strong) NSMutableArray *moneyArray;
@property (nonatomic, strong) NSMutableArray *redMoneyArr;

@property (nonatomic, copy) NSString *earliest;
@property (nonatomic, copy) NSString *latest;


@property (nonatomic, strong) CCZSegementController *inSegementController;

@property (nonatomic, strong) CCZSegementController *outSegementController;


@end

@implementation SHBillListVController

- (NSMutableArray *)moneyArray
{
    if (!_moneyArray) {
        _moneyArray = [NSMutableArray array];
    }
    return _moneyArray;
}

- (NSMutableArray *)redMoneyArr
{
    if (!_redMoneyArr) {
        _redMoneyArr = [NSMutableArray array];
    }
    return _redMoneyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
//    [self loadMoneyListData:@"" andType:0];
//    [self loadRedpackageListData:@"" andType:0];
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"零钱明细";
    
    CGFloat status_H = [UIApplication sharedApplication].statusBarFrame.size.height +  44;
    CGRect rect = CGRectMake(self.view.x, 0, SHScreenW, SHScreenH - status_H);
    NSArray *titleArray = @[@"我的零钱", @"红包余额"];
    NSArray *orderStatusArr = @[@"balance",@"redCash"];
    NSMutableArray *childVCArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < titleArray.count; i ++) {
        SHOrderLisrChildViewController *vc = [[SHOrderLisrChildViewController alloc]init];
        vc.orderStatus = orderStatusArr[i];
        //vc.isShelve = 0;
        vc.listType = SHMyWalletListType;
        [childVCArr addObject:vc];
    }
    self.outSegementController = [CCZSegementController segementControllerWithFrame:rect
                                                                             titles:titleArray];
    [self.outSegementController setSegementViewControllers:[childVCArr copy]];
    self.outSegementController.normalColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.outSegementController.segementTintColor = [UIColor colorWithRed:0 / 255.0 green:158 / 255.0 blue:231 / 255.0 alpha:1];
    self.outSegementController.style = CCZSegementStyleFlush;
    [self addChildViewController:self.outSegementController];
    [self.view addSubview:self.outSegementController.view];
    
    
//    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
//
//    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(_walletBtn.x, _walletBtn.height, _walletBtn.width, 2)];
//    _bottomView.backgroundColor = navColor;
//    [_walletBtn setTitleColor:navColor forState:UIControlStateNormal];
//    [_btnBgView addSubview:_bottomView];
//
//    _tempBtn = _walletBtn;
//
//
//    SHWeakSelf
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadMoneyListData:@"0" andType:0];
//    }];
    
    
}

//余额
- (void)loadMoneyListData:(NSString *)timeStamp andType:(NSInteger)type
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"bizType":@"balance",
                          @"current":timeStamp,
                          @"type":@(type),
                          @"pageSize":@(20)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMoneyListDataUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        self.tableView.hidden = NO;
        [weakSelf endRefresh];
        if (code == 0) {
            NSDictionary *dic = JSON[@"pageResult"];
            
            NSMutableArray *array = [SHMoneyModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
            if (array.count < 20) {
                if (type == 1 || type == 0) {
                    [self removeFooter];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self addFooter];
            }
            if (type == 0 || type == 1) {
                [self.moneyArray removeAllObjects];
            }
            [weakSelf.moneyArray addObjectsFromArray:array];
            SHLog(@"%@", weakSelf.moneyArray)
            [_tableView reloadData];
            [weakSelf handleFooter];
        }
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    
    
}

//红包
- (void)loadRedpackageListData:(NSString *)timeStamp andType:(NSInteger)type
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"bizType":@"redCash",
                          @"current":timeStamp,
                          @"type":@(type),
                          @"pageSize":@(20)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMoneyListDataUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
    } failure:^(NSError *error) {
        
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
        return;
    }
    SHWeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoneyListData:weakSelf.earliest andType:2];
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
    if (self.moneyArray.count == 0) {
        SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
        self.tableView.tableFooterView = footer;
    }
}



- (IBAction)btnClick:(UIButton *)sender {
    
    SHWeakSelf
    if (sender == _tempBtn) {
        
    } else {
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tempBtn = sender;
        if (sender.tag == 10) {
            SHLog(@"adf")
            [UIView animateWithDuration:0.2 animations:^{
                _bottomView.frame = CGRectMake(_walletBtn.x, _walletBtn.height, _walletBtn.width, 2);
            }];
        } else {
            SHLog(@"qwerqwe")
            [UIView animateWithDuration:0.2 animations:^{
                _bottomView.frame = CGRectMake(SHScreenW / 2 + _redMoneyBtn.x, _redMoneyBtn.height, _redMoneyBtn.width, 2);
            }];
            
        }
        
        [sender setTitleColor:navColor forState:UIControlStateNormal];
    }
    
}



#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SHLog(@"%@", self.moneyArray)
    return self.moneyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
    SHMoneyModel *model = self.moneyArray[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHBillDetailViewController *vc = [[SHBillDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
