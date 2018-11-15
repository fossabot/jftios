//
//  SHOrderLisrChildViewController.m
//  SGMJ
//
//  Created by 曾建国 on 2018/8/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHOrderLisrChildViewController.h"
#import "SHOrderListCell.h"
#import "SHOrderListModel.h"
#import "SHNoDataTableViewFooter.h"

#import "SHMyOrderDetailVController.h"
#import "SHAdDetailViewController.h"
#import "SHNeedTableViewCell.h"
#import "SHNeedTingModel.h"

#import "SHNeedDetailVController.h"
#import "SHMyReleaseCell.h"

#import "SHMyReleaseModel.h"
#import "SHMyReleNeedModel.h"
#import "SHMyReleAdverModel.h"
#import "SHMoneyModel.h"
#import "SHBillListCell.h"
#import "SHBillDetailViewController.h"
#import "SHAnswerQuesVController.h"
#import "SHGoodDetailVController.h"
#import "SHApplySkillVController.h"
#import "SHMyEvaluateTViewCell.h"
#import "SHMyEvaluateModel.h"
#import "SHEvaluteDetailViewController.h"

static NSString *identityNeedCell = @"SHNeedTableViewCell";
static NSString *releaseCell = @"SHMyReleaseCell";
static NSString *billListCell = @"SHBillListCell";
static NSString *evaluateCell = @"SHMyEvaluateTViewCell";
@interface SHOrderLisrChildViewController ()<UITableViewDataSource, UITableViewDelegate, SHOrderStatusChangeDelegate,SHOrderDoneDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *heightArray;

@property (nonatomic, strong) NSString *earliest;
@property (nonatomic, strong) NSString *latest;

@end

@implementation SHOrderLisrChildViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.hidden = YES;
        if (self.listType == SHOrderType) {
            [_tableView registerNib:[UINib nibWithNibName:@"SHOrderListCell" bundle:nil] forCellReuseIdentifier:@"SHOrderListCell"];
        } else if (self.listType == SHNeedTingType) {
            [_tableView registerClass:[SHNeedTableViewCell class] forCellReuseIdentifier:identityNeedCell];
        } else if (self.listType == SHMyReleaseType) {
            [_tableView registerNib:[UINib nibWithNibName:releaseCell bundle:nil] forCellReuseIdentifier:releaseCell];
            _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        } else if (self.listType == SHMyWalletListType) {
            [_tableView registerNib:[UINib nibWithNibName:billListCell bundle:nil] forCellReuseIdentifier:billListCell];
        } else if (self.listType == SHMyEvaluateType) {
            [_tableView registerClass:[SHMyEvaluateTViewCell class] forCellReuseIdentifier:evaluateCell];
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

- (NSMutableArray *)heightArray
{
    if (!_heightArray) {
        _heightArray = [[NSMutableArray alloc] init];
    }
    return _heightArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.listType == SHOrderType) {
        
        [self layout];
        [self requestDataWithType:0 AndCurrent:@""];
    } else if (self.listType == SHNeedTingType) {
        [self layoutNeed];
        [self requestNeedDataWithType:0 AndCurrent:@""];
    } else if (self.listType == SHMyReleaseType) {
        [self layoutMyRealease];
        [self loadMyReleaseDataWithType:0 andCurrent:@""];
        
    } else if (self.listType == SHMyWalletListType) {
        [self layoutMyWallet];
        [self loadMyWalletDataWithType:0 andCurrent:@""];
    } else if (self.listType == SHMyEvaluateType) {
        [self layoutMyEvaluteList];
        [self loadMyEvaluteDataWithType:0 andCurrent:@""];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowReceiveOrder) name:@"refreshOrderList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeReceiveOrder) name:@"removeOrderList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadListData) name:@"LoadOrderList" object:nil];
    
    
    
}

//重新加载列表
- (void)reloadListData
{
    [self requestDataWithType:0 AndCurrent:@""];
}

//开始接单
- (void)allowReceiveOrder
{
    [self layoutNeed];
    [self requestNeedDataWithType:0 AndCurrent:@""];
    
}

//关闭接单
- (void)closeReceiveOrder
{
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - 加载数据
- (void)layout
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    SHWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataWithType:0 AndCurrent:@"0"];
    }];
    
}

- (void)layoutNeed
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    SHWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestNeedDataWithType:0 AndCurrent:@"0"];
    }];
}

- (void)layoutMyRealease
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    SHWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMyReleaseDataWithType:0 andCurrent:@"0"];
    }];
    
}

- (void)layoutMyWallet
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    SHWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMyWalletDataWithType:0 andCurrent:@"0"];
    }];
    
}

- (void)layoutMyEvaluteList
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    SHWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMyEvaluteDataWithType:0 andCurrent:@"0"];
    }];
    
}

#pragma mark - 加载我的订单
- (void)requestDataWithType:(NSInteger)type AndCurrent:(NSString *)current
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"isCustomer":@(self.isCustomer),
                          @"orderStatus":self.orderStatus,
                          @"current":current,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    SHLog(@"%@", dic)

    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHOrderListUrl params:dic success:^(id JSON, int code, NSString *msg) {
        self.tableView.hidden = NO;
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
        SHLog(@"%@", self.orderStatus)
        SHLog(@"%d", self.isCustomer)
        if (code == 0) {
            SHLog(@"%@",JSON);
            NSDictionary *dic = JSON[@"pageResult"];
            self.earliest = dic[@"earliest"];
            self.latest = dic[@"latest"];
            NSArray *arr = [SHOrderListModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
            if (arr.count < 10) {
                if (type == 1 || type == 0) {
                    [self removeFooter];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self addFooter];
            }
            if (type == 1 || type == 0) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:arr];
            [self.tableView reloadData];
            [self handleFooter];
        }
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 大厅
//大厅数据请求
- (void)requestNeedDataWithType:(NSInteger)type AndCurrent:(NSString *)current
{
    NSDictionary *dic = @{
                          @"mainCat":self.idString ? self.idString : @"",
                          @"status":@"",
                          @"current":current,
                          @"type":@(type),
                          @"pageSize":@(10),
                          @"lat":@(SH_AppDelegate.personInfo.latitude),
                          @"lng":@(SH_AppDelegate.personInfo.longitude)
                          };
    //SHLog(@"%@", dic);
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHNeedTingUrl params:dic success:^(id JSON, int code, NSString *msg) {
        self.tableView.hidden = NO;
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
        if (code == 0) {
            SHLog(@"%@",JSON);
            
            NSString *isOpen = JSON[@"isOpen"];
            NSDictionary *dict = @{
                                   @"isOpen":isOpen
                                   };
            //SHLog(@"%@", dict)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkIsOpen" object:nil userInfo:dict];
            NSDictionary *dic = JSON[@"pageResult"];
            self.earliest = dic[@"earliest"];
            self.latest = dic[@"latest"];
            NSArray *arr = [SHNeedTingModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
            if (arr.count < 10) {
                if (type == 1 || type == 0) {
                    [self removeFooter];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self addFooter];
            }
            if (type == 1 || type == 0) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:arr];
            
            for (SHNeedTingModel *model in self.dataArr) {
                CGFloat cellHeight = [SHNeedTableViewCell cellHeightWithModel:model];
                [self.heightArray addObject:[NSNumber numberWithFloat:cellHeight]];
            }
            
            //SHLog(@"%@", self.dataArr)
            [self.tableView reloadData];
            [self handleFooter];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 我的发布
//我的发布
- (void)loadMyReleaseDataWithType:(NSInteger)type andCurrent:(NSString *)current
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"status":@(self.isShelve),
                          @"queryType":self.orderStatus,
                          @"current":current,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMyPublishUrl params:dic success:^(id JSON, int code, NSString *msg) {
        self.tableView.hidden = NO;
        [MBProgressHUD hideHUDForView:self.view];
        [self endRefresh];
        
        if (code == 0) {
            SHLog(@"%@", self.orderStatus)
            SHLog(@"我的发布%@", JSON)
            NSDictionary *dic = JSON[@"pageResult"];
            self.earliest = dic[@"earliest"];
            self.latest = dic[@"latest"];
//            NSMutableArray *array = [NSMutableArray array];
            if ([self.orderStatus isEqualToString:@"ad"]) {
                NSArray *arr = [SHMyReleAdverModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
                if (arr.count < 10) {
                    if (type == 1 || type == 0) {
                        [self removeFooter];
                    } else {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } else {
                    [self addFooter];
                }
                if (type == 1 || type == 0) {
                    [self.dataArr removeAllObjects];
                }
                [self.dataArr addObjectsFromArray:arr];
            } else if ([self.orderStatus isEqualToString:@"serve"]) {
                NSArray *arr = [SHMyReleaseModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
                if (arr.count < 10) {
                    if (type == 1 || type == 0) {
                        [self removeFooter];
                    } else {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } else {
                    [self addFooter];
                }
                if (type == 1 || type == 0) {
                    [self.dataArr removeAllObjects];
                }
                [self.dataArr addObjectsFromArray:arr];
            } else if ([self.orderStatus isEqualToString:@"need"]) {
                NSArray *arr = [SHMyReleNeedModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
                if (arr.count < 10) {
                    if (type == 1 || type == 0) {
                        [self removeFooter];
                    } else {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } else {
                    [self addFooter];
                }
                if (type == 1 || type == 0) {
                    [self.dataArr removeAllObjects];
                }
                [self.dataArr addObjectsFromArray:arr];
            }
            
            SHLog(@"%@", self.dataArr)
            [self.tableView reloadData];
            [self handleFooter];
        }
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 钱包页面
//钱包
- (void)loadMyWalletDataWithType:(NSInteger)type andCurrent:(NSString *)current
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"bizType":self.orderStatus,
                          @"current":current,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    SHLog(@"零钱的参数:%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMoneyListDataUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"零钱的数据:%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        self.tableView.hidden = NO;
        [weakSelf endRefresh];
        if (code == 0) {
            NSDictionary *dic = JSON[@"pageResult"];
            self.earliest = dic[@"earliest"];
            self.latest = dic[@"latest"];
            NSMutableArray *array = [SHMoneyModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
            if (array.count < 10) {
                if (type == 1 || type == 0) {
                    [self removeFooter];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self addFooter];
            }
            if (type == 0 || type == 1) {
                [self.dataArr removeAllObjects];
            }
            [weakSelf.dataArr addObjectsFromArray:array];
            SHLog(@"%@", weakSelf.dataArr)
            [_tableView reloadData];
            [weakSelf handleFooter];
        }
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

#pragma mark - 我的评价
//我的评价
- (void)loadMyEvaluteDataWithType:(NSInteger)type andCurrent:(NSString *)current
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"checkType":self.orderStatus,
                          @"current":current,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    SHLog(@"评价的参数:%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMyEvaluateListUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", self.orderStatus)
        //SHLog(@"我的评价的数据:%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        self.tableView.hidden = NO;
        [weakSelf endRefresh];
        if (code == 0) {
            NSDictionary *dic = JSON[@"pageResult"];
            self.earliest = dic[@"earliest"];
            self.latest = dic[@"latest"];
            SHLog(@"%@", dic)
            NSMutableArray *array = [SHMyEvaluateModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
            SHLog(@"%@", array)
            if (array.count < 10) {
                if (type == 1 || type == 0) {
                    [self removeFooter];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self addFooter];
            }
            if (type == 0 || type == 1) {
                [self.dataArr removeAllObjects];
            }
            [weakSelf.dataArr addObjectsFromArray:array];
            SHLog(@"%@", weakSelf.dataArr)
            [_tableView reloadData];
            [weakSelf handleFooter];
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

//footer的处理
- (void)addFooter
{
    if (self.tableView.mj_footer) {
        return;
    }
    SHWeakSelf
    if (self.listType == SHOrderType) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestDataWithType:2 AndCurrent:weakSelf.earliest];
        }];
    } else if (self.listType == SHNeedTingType) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestNeedDataWithType:2 AndCurrent:weakSelf.earliest];
        }];
    } else if (self.listType == SHMyReleaseType) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMyReleaseDataWithType:2 andCurrent:weakSelf.earliest];
        }];
    } else if (self.listType == SHMyWalletListType) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMyWalletDataWithType:2 andCurrent:weakSelf.earliest];
        }];
    } else if (self.listType == SHMyEvaluateType) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMyEvaluteDataWithType:2 andCurrent:weakSelf.earliest];
        }];
    }
    
    
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
    if (self.dataArr.count == 0) {
        SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
        self.tableView.tableFooterView = footer;
    }

}

#pragma mark --- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cellOne = [[UITableViewCell alloc] init];
    if (self.listType == SHOrderType) {
        SHOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHOrderListCell class])];
        if (!cell) {
            cell = [[SHOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SHOrderListCell class])];
        }
        SHOrderListModel *model = self.dataArr[indexPath.row];
        cell.listModel = model;
        cell.delegate = self;
        
        
        
        cellOne = cell;
    } else if (self.listType == SHNeedTingType) {
        SHNeedTableViewCell *needCell = [tableView dequeueReusableCellWithIdentifier:identityNeedCell];
        if (!needCell) {
            needCell = [[SHNeedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityNeedCell];
        } 
        SHNeedTingModel *model = self.dataArr[indexPath.row];
        [needCell createMainViewCellWithSHNeedTingModel:model];
        
        cellOne = needCell;
        
    } else if (self.listType == SHMyReleaseType) {
        SHMyReleaseCell *relCell = [tableView dequeueReusableCellWithIdentifier:releaseCell];
        if (!relCell) {
            relCell = [[SHMyReleaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:releaseCell];
        }
        if ([self.orderStatus isEqualToString:@"ad"]) {
            SHMyReleAdverModel *model = self.dataArr[indexPath.row];
            relCell.titleL.text = model.title;
            relCell.secTitleL.text = model.introduce;
            [relCell.picImgV sd_setImageWithURL:model.pics[0] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        } else if ([self.orderStatus isEqualToString:@"serve"]) {
            SHMyReleaseModel *model = self.dataArr[indexPath.row];
            relCell.titleL.text = model.title;
            relCell.secTitleL.text = [NSString stringWithFormat:@"%.2f元/%@", model.price, model.unit];
            [relCell.picImgV sd_setImageWithURL:model.imageList[0] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        } else if ([self.orderStatus isEqualToString:@"need"]) {
            SHMyReleNeedModel *model = self.dataArr[indexPath.row];
            relCell.titleL.text = model.mainCatName;
            relCell.secTitleL.text = model.title;
            relCell.picImgV.hidden = YES;
            relCell.marginLeftContraint.constant = 13;
        }
        if (self.isShelve == 0) {
            relCell.shelvesImgV.hidden = YES;
        } else if (self.isShelve == 1) {
            relCell.shelvesImgV.hidden = NO;
        }
        
        cellOne = relCell;
    } else if (self.listType == SHMyWalletListType) {
        SHBillListCell *billCell = [tableView dequeueReusableCellWithIdentifier:billListCell];
        if (!billCell) {
            billCell = [[SHBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billListCell];
        }
        
        SHMoneyModel *model = self.dataArr[indexPath.row];
        [billCell setModel:model];
        cellOne = billCell;
    } else if (self.listType == SHMyEvaluateType) {
        SHMyEvaluateTViewCell *evaCell = [tableView dequeueReusableCellWithIdentifier:evaluateCell];
        if (!evaCell) {
            evaCell = [[SHMyEvaluateTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SHMyEvaluateTViewCell class])];
        }
        SHMyEvaluateModel *evalModel = self.dataArr[indexPath.row];
        [evaCell setEvaluateModel:evalModel];
        cellOne = evaCell;
    }
    
    return cellOne;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listType == SHNeedTingType) {
        SHNeedTingModel *model = self.dataArr[indexPath.row];
        NSNumber *cellHeight = self.heightArray[indexPath.row];
        return [cellHeight doubleValue];
    } else if (self.listType == SHMyReleaseType) {
        return 128;
    } else if (self.listType == SHMyWalletListType) {
        return 60;
    } else if (self.listType == SHMyEvaluateType) {
        SHMyEvaluateModel *model = self.dataArr[indexPath.row];
        NSString *string = model.content;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange allRange = [string rangeOfString:string];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:allRange];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
        CGFloat titleHeight;
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        // 获取label的最大宽度
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SHScreenW - 81, CGFLOAT_MAX)options:options context:nil];
        titleHeight = ceilf(rect.size.height);
        if (model.images.count > 0) {
            return 151 + titleHeight + 70;
        }
        return 151 + titleHeight;
    }
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHWeakSelf
    if (self.listType == SHOrderType) {
        SHMyOrderDetailVController *vc = [[SHMyOrderDetailVController alloc] init];
        SHAdDetailViewController *adVC = [[SHAdDetailViewController alloc] init];
        vc.inType = SHOrderListPushType;
        SHOrderListModel *model = self.dataArr[indexPath.row];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            vc.changeBlock = ^(NSString *string) {
                SHLog(@"%@", string)
                [weakSelf requestDataWithType:0 AndCurrent:@"0"];
            };
            if (!AppDelegate.isLocationServiceOpen) {

                if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
                {
                    CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
                    [locationManager requestAlwaysAuthorization];
                    [locationManager requestWhenInUseAuthorization];
                }
                UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"打开定位开关提供更优质的服务" message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertView addAction:sureAction];
                [alertView addAction:cancelAction];
                
                [self presentViewController:alertView animated:YES completion:nil];
                
            } else {
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    } else if (self.listType == SHNeedTingType) {
        SHLog(@"点击大厅订单")
        SHNeedDetailVController *vc = [[SHNeedDetailVController alloc] init];
        SHNeedTingModel *model = self.dataArr[indexPath.row];
        vc.needId = model.needId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.listType == SHMyWalletListType) {
        SHLog(@"点击")
        SHBillDetailViewController *vc = [[SHBillDetailViewController alloc] init];
        SHMoneyModel *model = self.dataArr[indexPath.row];
        vc.moneyModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.listType == SHMyReleaseType) {
        if ([self.orderStatus isEqualToString:@"ad"]) {
            SHMyReleAdverModel *model = self.dataArr[indexPath.row];
            //广告
            SHAnswerQuesVController *vc = [[SHAnswerQuesVController alloc] init];
            vc.modelId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([self.orderStatus isEqualToString:@"serve"]) {
            SHMyReleaseModel *model = self.dataArr[indexPath.row];
            //服务
            SHGoodDetailVController *vc = [[SHGoodDetailVController alloc] init];
            vc.provideId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([self.orderStatus isEqualToString:@"need"]) {
            SHMyReleNeedModel *model = self.dataArr[indexPath.row];
            //需求
            SHNeedDetailVController *vc = [[SHNeedDetailVController alloc] init];
            vc.needId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (self.listType == SHMyEvaluateType) {
        SHEvaluteDetailViewController *vc = [[SHEvaluteDetailViewController alloc] init];
        SHMyEvaluateModel *model = self.dataArr[indexPath.row];
        vc.typeString = self.orderStatus;
        vc.evaluateId = model.assessId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}


#pragma mark - SHOrderStatusChangeDelegate
- (void)changeOrderStatus:(SHOrderChangeStatusType)status
{
    SHLog(@"刷新")
    [self requestDataWithType:0 AndCurrent:@""];
    
}




@end
















