
//
//  SHMyOrderCenterVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMyOrderCenterVController.h"
#import "SHOrderListModel.h"
#import "SHOrderListCell.h"
#import "SHMyOrderDetailVController.h"
#import "SHAdDetailViewController.h"


static NSString *identityCell = @"SHOrderListCell";
@interface SHMyOrderCenterVController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *titView;
@property (nonatomic, strong) UIButton *inButton;
@property (nonatomic, strong) UIButton *outButton;
@property (nonatomic, strong) UIButton *tempBuyBtn;             //买入卖出中间按钮

/**
 *  btn底部的颜色线
 */
@property (nonatomic, strong) UIView *navBottomView;
/**
 *  承载tableView的背景Scrollview
 */
@property (nonatomic, strong) UIScrollView *backGroundScr;
@property (nonatomic, strong) UIScrollView *sellBackGroundScr;

/**
 *  scr中的五个tableview
 */
@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, strong) UITableView *thirdTableView;
@property (nonatomic, strong) UITableView *fourthTableView;
@property (nonatomic, strong) UITableView *fifthTableView;
/**
 *  btn名称数组
 */
@property (nonatomic, strong) NSArray *titleArray;
/**
 *  承载btn的view
 */
@property (nonatomic, strong) UIView *backGroundView;
/**
 *  将button全局化,买入
 */
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;

@property (nonatomic, strong) UIButton *tempBtn;                //买入中间按钮

/**
 *  卖出
 */
/**
 *  卖出btn底部的颜色线
 */
@property (nonatomic, strong) UIView *sellBottomView;
/**
 *  卖出的四个tableView
 */
@property (nonatomic, strong) UITableView *sellFirstTableView;
@property (nonatomic, strong) UITableView *sellSecTabView;
@property (nonatomic, strong) UITableView *sellThirdTabView;
@property (nonatomic, strong) UITableView *sellForTabView;

/**
 *  卖出btn的名称数组
 */
@property (nonatomic, strong) NSArray *sellTitleArray;
/**
 *  卖出的btn
 */
@property (nonatomic, strong) UIButton *sellBtn1;
@property (nonatomic, strong) UIButton *sellBtn2;
@property (nonatomic, strong) UIButton *sellBtn3;
@property (nonatomic, strong) UIButton *sellBtn4;

@property (nonatomic, strong) UIButton *tempSellBtn;            //卖出的中间按钮

@property (nonatomic, strong) NSMutableArray *buyArray;         //消费全部
@property (nonatomic, strong) NSMutableArray *buyPayArray;      //待付款
@property (nonatomic, strong) NSMutableArray *buySendArray;     //待发货
@property (nonatomic, strong) NSMutableArray *buyReceiveArray;  //待收货
@property (nonatomic, strong) NSMutableArray *buyEvalArray;     //待评价

@property (nonatomic, strong) NSMutableArray *sellArray;        //收入全部
@property (nonatomic, strong) NSMutableArray *sellSendArray;    //待发货
@property (nonatomic, strong) NSMutableArray *sellReceiveArray; //待收货
@property (nonatomic, strong) NSMutableArray *sellEvalArray;    //待评价

@property (nonatomic, strong) UIView *nodataView;
@property (nonatomic, strong) UILabel *nodataLabel;



@property (nonatomic, copy) NSString *timeFirstStamp;
@property (nonatomic, copy) NSString *timeSecStamp;
@property (nonatomic, copy) NSString *timeThirdStamp;
@property (nonatomic, copy) NSString *timeFourStamp;
@property (nonatomic, copy) NSString *timeFiveStamp;

@property (nonatomic, copy) NSString *timeSellStamp;
@property (nonatomic, copy) NSString *timeSendStamp;
@property (nonatomic, copy) NSString *timeReceiveStamp;
@property (nonatomic, copy) NSString *timeEvalStamp;

@end

@implementation SHMyOrderCenterVController

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"全部",@"待付款",@"待服务",@"待确认",@"待评价"];
    }
    return _titleArray;
}

- (NSArray *)sellTitleArray
{
    if (!_sellTitleArray) {
        _sellTitleArray = @[@"全部",@"待服务",@"待确认",@"待评价"];
    }
    return _sellTitleArray;
}

- (NSMutableArray *)buyArray
{
    if (!_buyArray) {
        _buyArray = [NSMutableArray array];
    }
    return _buyArray;
}

- (NSMutableArray *)buyPayArray
{
    if (!_buyPayArray) {
        _buyPayArray = [NSMutableArray array];
    }
    return _buyPayArray;
}

- (NSMutableArray *)buySendArray
{
    if (!_buySendArray) {
        _buySendArray = [NSMutableArray array];
    }
    return _buySendArray;
}

- (NSMutableArray *)buyReceiveArray
{
    if (!_buyReceiveArray) {
        _buyReceiveArray = [NSMutableArray array];
    }
    return _buyReceiveArray;
}

- (NSMutableArray *)buyEvalArray
{
    if (!_buyEvalArray) {
        _buyEvalArray = [NSMutableArray array];
    }
    return _buyEvalArray;
}

- (NSMutableArray *)sellArray
{
    if (!_sellArray) {
        _sellArray = [NSMutableArray array];
    }
    return _sellArray;
}

- (NSMutableArray *)sellSendArray
{
    if (!_sellSendArray) {
        _sellSendArray = [NSMutableArray array];
    }
    return _sellSendArray;
}

- (NSMutableArray *)sellReceiveArray
{
    if (!_sellReceiveArray) {
        _sellReceiveArray = [NSMutableArray array];
    }
    return _sellReceiveArray;
}

- (NSMutableArray *)sellEvalArray
{
    if (!_sellEvalArray) {
        _sellEvalArray = [NSMutableArray array];
    }
    return _sellEvalArray;
}

- (UITableView *)firstTableView
{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*0, 0, SHScreenW, SHScreenH-50-64)];
        _firstTableView.tag = 0;
        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        [_firstTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _firstTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.backGroundScr addSubview:_firstTableView];
    }
    return _firstTableView;
}

- (UITableView *)secondTableView
{
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*1, 0, SHScreenW, SHScreenH-50-64)];
        _secondTableView.tag = 1;
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        [_secondTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _secondTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.backGroundScr addSubview:_secondTableView];
    }
    return _secondTableView;
}

- (UITableView *)thirdTableView
{
    if (!_thirdTableView) {
        _thirdTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*2, 0, SHScreenW, SHScreenH-50-64)];
        _thirdTableView.tag = 2;
        _thirdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _thirdTableView.delegate = self;
        _thirdTableView.dataSource = self;
        [_thirdTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _thirdTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.backGroundScr addSubview:_thirdTableView];
    }
    return _thirdTableView;
}

- (UITableView *)fourthTableView
{
    if (!_fourthTableView) {
        _fourthTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*3, 0, SHScreenW, SHScreenH-50-64)];
        _fourthTableView.tag = 3;
        _fourthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fourthTableView.delegate = self;
        _fourthTableView.dataSource = self;
        [_fourthTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _fourthTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.backGroundScr addSubview:_fourthTableView];
    }
    return _fourthTableView;
}

- (UITableView *)fifthTableView
{
    if (!_fifthTableView) {
        _fifthTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*4, 0, SHScreenW, SHScreenH-50-64)];
        _fifthTableView.tag = 4;
        _fifthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fifthTableView.delegate = self;
        _fifthTableView.dataSource = self;
        [_fifthTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _fifthTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.backGroundScr addSubview:_fifthTableView];
    }
    return _fifthTableView;
}

- (UITableView *)sellFirstTableView
{
    if (!_sellFirstTableView) {
        _sellFirstTableView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*0, 0, SHScreenW, SHScreenH-50-64)];
        _sellFirstTableView.tag = 0 + 5;
        _sellFirstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _sellFirstTableView.delegate = self;
        _sellFirstTableView.dataSource = self;
        [_sellFirstTableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _sellFirstTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.sellBackGroundScr addSubview:_sellFirstTableView];
    }
    return _sellFirstTableView;
}


- (UITableView *)sellSecTabView
{
    if (!_sellSecTabView) {
        _sellSecTabView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*1, 0, SHScreenW, SHScreenH-50-64)];
        _sellSecTabView.tag = 1 + 5;
        _sellSecTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _sellSecTabView.delegate = self;
        _sellSecTabView.dataSource = self;
        [_sellSecTabView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _sellSecTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.sellBackGroundScr addSubview:_sellSecTabView];
    }
    return _sellSecTabView;
}

- (UITableView *)sellThirdTabView
{
    if (!_sellThirdTabView) {
        _sellThirdTabView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*2, 0, SHScreenW, SHScreenH-50-64)];
        _sellThirdTabView.tag = 2 + 5;
        _sellThirdTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _sellThirdTabView.delegate = self;
        _sellThirdTabView.dataSource = self;
        [_sellThirdTabView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _sellThirdTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.sellBackGroundScr addSubview:_sellThirdTabView];
    }
    return _sellThirdTabView;
}

- (UITableView *)sellForTabView
{
    if (!_sellForTabView) {
        _sellForTabView = [[UITableView alloc] initWithFrame:CGRectMake(SHScreenW*3, 0, SHScreenW, SHScreenH-50-64)];
        _sellForTabView.tag = 3 + 5;
        _sellForTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _sellForTabView.delegate = self;
        _sellForTabView.dataSource = self;
        [_sellForTabView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
        
        _sellForTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 9)];
        [self.sellBackGroundScr addSubview:_sellForTabView];
    }
    return _sellForTabView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //return
    //SHColorFromHex(0x00a9f0)
    //字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //修改返回按钮
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 30, 44);
    UIImage * bImage = [[UIImage imageNamed: @"returnBack"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn addTarget:self action:@selector(back) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage:bImage forState: UIControlStateNormal];
    UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = - 20;
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, lb];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0x00a9f0);
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
    self.sellFirstTableView.hidden = YES;
    self.sellSecTabView.hidden = YES;
    self.sellThirdTabView.hidden = YES;
    self.sellForTabView.hidden = YES;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAllListData) name:@"listRefresh" object:nil];
    
    [self loadAllListData];
    
    [self setDownAndUpLoadingData];
    
}

//上拉加载下拉刷新
- (void)setDownAndUpLoadingData
{
    SHWeakSelf
    self.firstTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SHLog(@"下拉刷新")
        weakSelf.timeFirstStamp = @"0";
        [self.firstTableView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"" andTime:weakSelf.timeFirstStamp andType:SHDownLoadingType andBuySell:SHBuyGoodsType];
        [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        [weakSelf.firstTableView.mj_header endRefreshing];
    }];
    
    //上拉加载
    self.firstTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        SHLog(@"上啦加载")
        [weakSelf.firstTableView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"" andTime:weakSelf.timeFirstStamp andType:SHUpLoadingType andBuySell:SHBuyGoodsType];
        [weakSelf.firstTableView.mj_footer endRefreshing];
    }];
    
    //第2 个
    self.secondTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SHLog(@"下拉刷新")
        weakSelf.timeSecStamp = @"0";
        [self.secondTableView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"INIT" andTime:weakSelf.timeSecStamp andType:SHDownLoadingType andBuySell:SHBuyGoodsType];
        
        if (weakSelf.buyPayArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.secondTableView.mj_header endRefreshing];
    }];
    
    //上拉加载
    self.secondTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        SHLog(@"上啦加载")
        [weakSelf.secondTableView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"INIT" andTime:weakSelf.timeSecStamp andType:SHUpLoadingType andBuySell:SHBuyGoodsType];
        [weakSelf.secondTableView.mj_footer endRefreshing];
    }];
    
    
    //第3个
    self.thirdTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.timeThirdStamp = @"0";
        [weakSelf.thirdTableView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"RECEIVE" andTime:weakSelf.timeThirdStamp andType:SHDownLoadingType andBuySell:SHBuyGoodsType];
        if (weakSelf.buySendArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.thirdTableView.mj_header endRefreshing];
    }];
    
    self.thirdTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.thirdTableView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"RECEIVE" andTime:weakSelf.timeThirdStamp andType:SHUpLoadingType andBuySell:SHBuyGoodsType];
        [weakSelf.thirdTableView.mj_footer endRefreshing];
    }];
    
    //第4个
    self.fourthTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.timeFourStamp = @"0";
        [weakSelf.fourthTableView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_CONFIRMED" andTime:@"0" andType:SHDownLoadingType andBuySell:SHBuyGoodsType];
        if (weakSelf.buyReceiveArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.fourthTableView.mj_header endRefreshing];
    }];
    
    self.fourthTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.fourthTableView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_CONFIRMED" andTime:weakSelf.timeFourStamp andType:SHUpLoadingType andBuySell:SHBuyGoodsType];
        [weakSelf.fourthTableView.mj_footer endRefreshing];
    }];
    
    //第5个
    self.fifthTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.timeFiveStamp = @"0";
        [weakSelf.fifthTableView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_EVALUATION" andTime:@"0" andType:SHDownLoadingType andBuySell:SHBuyGoodsType];
        if (weakSelf.buyEvalArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.fifthTableView.mj_header endRefreshing];
    }];
    //self.fifthTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.fifthTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.fifthTableView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_EVALUATION" andTime:weakSelf.timeFiveStamp andType:SHUpLoadingType andBuySell:SHBuyGoodsType];
        [weakSelf.fifthTableView.mj_footer endRefreshingWithNoMoreData];
        
    }];
    
    
    //收入tableview
    self.sellFirstTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.timeSellStamp = @"0";
        [weakSelf.sellFirstTableView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"" andTime:weakSelf.timeSellStamp andType:SHDownLoadingType andBuySell:SHSellGoodsType];
        if (weakSelf.sellArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.sellFirstTableView.mj_header endRefreshing];
    }];
    self.sellFirstTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.sellFirstTableView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"" andTime:weakSelf.timeSellStamp andType:SHUpLoadingType andBuySell:SHSellGoodsType];
        [weakSelf.sellFirstTableView.mj_footer endRefreshing];
    }];
    
    //待发货
    self.sellSecTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.timeSendStamp = @"0";
        [weakSelf.sellSecTabView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"RECEIVE" andTime:weakSelf.timeSendStamp andType:SHDownLoadingType andBuySell:SHSellGoodsType];
        if (weakSelf.sellSendArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.sellSecTabView.mj_header endRefreshing];
    }];
    self.sellSecTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.sellSecTabView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"RECEIVE" andTime:weakSelf.timeSecStamp andType:SHUpLoadingType andBuySell:SHSellGoodsType];
        [weakSelf.sellSecTabView.mj_footer endRefreshing];
    }];
    
    //待收货
    self.sellThirdTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.timeReceiveStamp = @"0";
        [weakSelf.sellThirdTabView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_CONFIRMED" andTime:weakSelf.timeReceiveStamp andType:SHDownLoadingType andBuySell:SHSellGoodsType];
        if (weakSelf.sellReceiveArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.sellThirdTabView.mj_header endRefreshing];
    }];
    self.sellThirdTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.sellThirdTabView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_CONFIRMED" andTime:weakSelf.timeReceiveStamp andType:SHUpLoadingType andBuySell:SHSellGoodsType];
        [weakSelf.sellThirdTabView.mj_footer endRefreshing];
    }];
    
    //待评价
    self.sellForTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.timeEvalStamp = @"0";
        [weakSelf.sellForTabView.mj_header beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_EVALUATION" andTime:weakSelf.timeFourStamp andType:SHDownLoadingType andBuySell:SHSellGoodsType];
        if (weakSelf.sellEvalArray.count > 0) {
            [MBProgressHUD showMBPAlertView:@"已更新最新数据" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:@"暂无数据" withSecond:2.0];
        }
        [weakSelf.sellForTabView.mj_header endRefreshing];
    }];
    self.sellForTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.sellForTabView.mj_footer beginRefreshing];
        [weakSelf loadOrderListBuyWithStatus:@"UN_EVALUATION" andTime:weakSelf.timeEvalStamp andType:SHUpLoadingType andBuySell:SHSellGoodsType];
        [weakSelf.sellForTabView.mj_footer endRefreshing];
    }];
    
    
    

}

//加载初始数据
- (void)loadAllListData
{
    //买入
    /**
     *  INIT待支付 RECEIVE 代发货 UN_CONFIRMED,//待收货（订单需要确认） UN_EVALUATION未评价 AFTER_SALES售后状态
     */
    [self loadOrderListBuyWithStatus:@"" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHBuyGoodsType];
    [self loadOrderListBuyWithStatus:@"INIT" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHBuyGoodsType];
    [self loadOrderListBuyWithStatus:@"RECEIVE" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHBuyGoodsType];
    [self loadOrderListBuyWithStatus:@"UN_CONFIRMED" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHBuyGoodsType];
    [self loadOrderListBuyWithStatus:@"UN_EVALUATION" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHBuyGoodsType];
    
    
    //卖出
    [self loadOrderListBuyWithStatus:@"" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHSellGoodsType];
    [self loadOrderListBuyWithStatus:@"RECEIVE" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHSellGoodsType];
    [self loadOrderListBuyWithStatus:@"UN_CONFIRMED" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHSellGoodsType];
    [self loadOrderListBuyWithStatus:@"UN_EVALUATION" andTime:@"0" andType:SHInTheFirstTimeType andBuySell:SHSellGoodsType];
}

- (void)initBaseInfo
{
    
    self.timeFirstStamp = @"0";
    self.timeSecStamp = @"0";
    self.timeThirdStamp = @"0";
    self.timeFourStamp = @"0";
    self.timeFiveStamp = @"0";
    
    self.timeSellStamp = @"0";
    self.timeSendStamp = @"0";
    self.timeReceiveStamp = @"0";
    self.timeEvalStamp = @"0";
    
    _titView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 122, 30)];
    _titView.layer.cornerRadius = 10;
    _titView.clipsToBounds = YES;
    self.navigationItem.titleView = _titView;
    
    _inButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 30)];
    [_inButton setTitle:@"消费" forState:UIControlStateNormal];
    _inButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_inButton setBackgroundColor:navColor];
    _inButton.tag = 1;
    [_inButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_inButton addTarget:self action:@selector(buyInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _outButton = [[UIButton alloc] initWithFrame:CGRectMake(61, 0, 61, 30)];
    [_outButton setTitle:@"收入" forState:UIControlStateNormal];
    [_outButton setBackgroundColor:SHColorFromHex(0xEBEBF1)];
    _outButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _outButton.tag = 2;
    [_outButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_outButton addTarget:self action:@selector(buyInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tempBuyBtn = _inButton;
    [_titView addSubview:_inButton];
    [_titView addSubview:_outButton];
    
    CGFloat btnWidth = (SHScreenW - 25 * 6) / 5;
    CGFloat btnHeight = 30;
    CGFloat sellBtnWidth = (SHScreenW - 25 * 5) / 4;
    
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 50)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backGroundView];
    
    self.sellBottomView = [[UIView alloc] initWithFrame:CGRectMake(25, 48, sellBtnWidth, 2)];
    self.sellBottomView.backgroundColor = navColor;
    self.sellBottomView.hidden = YES;
    [self.backGroundView addSubview:self.sellBottomView];
    
    self.navBottomView = [[UIView alloc] initWithFrame:CGRectMake(25, 48, btnWidth, 2)];
    self.navBottomView.backgroundColor = navColor;
    [self.backGroundView addSubview:self.navBottomView];
    
    self.backGroundScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backGroundView.frame), SHScreenW, SHScreenH - 114)];
    self.backGroundScr.contentSize = CGSizeMake(SHScreenW * 5, 0);
    self.backGroundScr.delegate = self;
    self.backGroundScr.pagingEnabled = YES;
    [self.view addSubview:self.backGroundScr];
    
    self.sellBackGroundScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backGroundView.frame), SHScreenW, SHScreenH - 114)];
    self.sellBackGroundScr.contentSize = CGSizeMake(SHScreenW * 4, 0);
    self.sellBackGroundScr.delegate = self;
    self.sellBackGroundScr.pagingEnabled = YES;
    self.sellBackGroundScr.hidden = YES;
    [self.view addSubview:self.sellBackGroundScr];
    
    
    self.nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHScreenW / 2 - 50, SHScreenH / 2 - 10, 100, 20)];
    self.nodataLabel.textAlignment = NSTextAlignmentCenter;
    self.nodataLabel.text = @"暂无数据";
    self.nodataLabel.hidden = YES;
    self.nodataLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:self.nodataLabel];
    
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.tag = i + 10;
        int x = i % 5;
        clickBtn.frame = CGRectMake(25 + (btnWidth + 25) * x, 10, btnWidth, btnHeight);
        [clickBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [clickBtn setTitleColor:navColor forState:UIControlStateNormal];
            _tempBtn = clickBtn;
        } else {
            [clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        if (i == self.orderType) {
            [self btnClick:clickBtn];
        }
        clickBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.backGroundView addSubview:clickBtn];
        [clickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (clickBtn.tag) {
            case 10:
                self.btn1 = clickBtn;
                break;
            case 11:
                self.btn2 = clickBtn;
                break;
            case 12:
                self.btn3 = clickBtn;
                break;
            case 13:
                self.btn4 = clickBtn;
                break;
            case 14:
                self.btn5 = clickBtn;
                break;
                
            default:
                break;
        }
        
    }
    
    
    for (int i = 0; i < self.sellTitleArray.count; i++) {
        UIButton *sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sellBtn.tag = i + 20;
        int x = i % 4;
        sellBtn.frame = CGRectMake(25 + (sellBtnWidth + 25) * x, 10, sellBtnWidth, btnHeight);
        [sellBtn setTitle:self.sellTitleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [sellBtn setTitleColor:navColor forState:UIControlStateNormal];
            _tempSellBtn = sellBtn;
        } else {
            [sellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        sellBtn.hidden = YES;
        sellBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.backGroundView addSubview:sellBtn];
        [sellBtn addTarget:self action:@selector(sellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (sellBtn.tag) {
            case 20:
                self.sellBtn1 = sellBtn;
                break;
            case 21:
                self.sellBtn2 = sellBtn;
                break;
            case 22:
                self.sellBtn3 = sellBtn;
                break;
            case 23:
                self.sellBtn4 = sellBtn;
                break;
            default:
                break;
        }
        
    }
    
   
    //[self.view addSubview:self.nodataView];
    
}


#pragma mark - scrollview滑动结束后调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.backGroundScr == scrollView) {
        float scrollViewX = scrollView.contentOffset.x;
        if (scrollViewX == 0) {
            [self btnClick:self.btn1];
            if (self.buyArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"1--------%ld",self.btn1.tag);
        } else if (scrollViewX == SHScreenW) {
            [self btnClick:self.btn2];
            if (self.buyPayArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"2--------%ld",self.btn1.tag);
        } else if (scrollViewX == SHScreenW * 2) {
            [self btnClick:self.btn3];
            if (self.buySendArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"3--------%ld",self.btn1.tag);
        } else if (scrollViewX == SHScreenW * 3) {
            [self btnClick:self.btn4];
            if (self.buyReceiveArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"4--------%ld",self.btn1.tag);
        } else if (scrollViewX == SHScreenW * 4) {
            [self btnClick:self.btn5];
            if (self.buyEvalArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"5--------%ld",self.btn1.tag);
        }
    
    } else if (scrollView == self.sellBackGroundScr) {
        float scrollViewX = scrollView.contentOffset.x;
        if (scrollViewX == 0) {
            [self sellBtnClick:self.sellBtn1];
            if (self.sellArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"1--------%ld",self.sellBtn1.tag);
        } else if (scrollViewX == SHScreenW) {
            [self sellBtnClick:self.sellBtn2];
            if (self.sellSendArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"2--------%ld",self.sellBtn2.tag);
        } else if (scrollViewX == SHScreenW * 2) {
            [self sellBtnClick:self.sellBtn3];
            if (self.sellReceiveArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"3--------%ld",self.sellBtn3.tag);
        } else if (scrollViewX == SHScreenW * 3) {
            [self sellBtnClick:self.sellBtn4];
            if (self.sellEvalArray.count == 0) {
                self.nodataLabel.hidden = NO;
                [self.view bringSubviewToFront:self.nodataLabel];
            } else {
                self.nodataLabel.hidden = YES;
            }
            SHLog(@"4--------%ld",self.sellBtn4.tag);
        }
    }
    
    
    
}


/**
 *  加载买入数据,卖出数据
 */
- (void)loadOrderListBuyWithStatus:(NSString *)buyString andTime:(NSString *)timeStap andType:(SHRefreshUpAndDownType)type andBuySell:(NSUInteger)buyOrSell
{
    SHWeakSelf
    /**   app/order/list
     *  isCustomer  0是买入 1 卖出
     *  type  0.第一次拉取   1.下拉刷新， 2上拉加载
     *  orderStatus 买入： ""-全部    INIT待支付 RECEIVE 代发货 UN_CONFIRMED,//待收货（订单需要确认） UN_EVALUATION待评价
     *              卖出： ""-全部    RECEIVE 代发货 UN_CONFIRMED,//待收货（订单需要确认） UN_EVALUATION未评价 AFTER_SALES售后状态
     *  current     时间戳
     *  pageSize    页容量
     */
    NSDictionary *dic = @{
                          @"isCustomer":@(buyOrSell),
                          @"orderStatus":buyString,
                          @"current":timeStap,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHOrderListUrl params:dic success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%d", code)
        //SHLog(@"%@", msg)
        //SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            NSDictionary *dic = JSON[@"pageResult"];
            NSMutableArray *allArray = [SHOrderListModel mj_objectArrayWithKeyValuesArray:dic[@"res"]];
            SHLog(@"%d", allArray.count)
            if (buyOrSell == SHBuyGoodsType) {
                if ([buyString isEqualToString:@""]) {
                    //SHLog(@"%@", JSON)
                    if (allArray.count > 0) {
                        if ([weakSelf.timeFirstStamp isEqualToString:@"0"]) {
                            [weakSelf.buyArray removeAllObjects];
                            [weakSelf.buyArray addObjectsFromArray:allArray];
                            weakSelf.timeFirstStamp = dic[@"latest"];
                        } else {
                            [weakSelf.buyArray addObjectsFromArray:allArray];
                            weakSelf.timeFirstStamp = dic[@"latest"];
                        }
                    }
                    
                    [weakSelf.firstTableView reloadData];
                }
                else if ([buyString isEqualToString:@"INIT"]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeSecStamp isEqualToString:@"0"]) {
                            [weakSelf.buyPayArray removeAllObjects];
                            [weakSelf.buyPayArray addObjectsFromArray:allArray];
                            weakSelf.timeSecStamp = dic[@"latest"];
                        } else {
                            [weakSelf.buyPayArray addObjectsFromArray:allArray];
                            weakSelf.timeSecStamp = dic[@"latest"];
                        }
                        
                    }
                    
                    [weakSelf.secondTableView reloadData];
                } else if ([buyString isEqualToString:@"RECEIVE"]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeThirdStamp isEqualToString:@"0"]) {
                            [weakSelf.buySendArray removeAllObjects];
                            [weakSelf.buySendArray addObjectsFromArray:allArray];
                            weakSelf.timeThirdStamp = dic[@"latest"];
                        } else {
                            [weakSelf.buySendArray addObjectsFromArray:allArray];
                            weakSelf.timeThirdStamp = dic[@"latest"];
                        }
                    }
                    [weakSelf.thirdTableView reloadData];
                } else if ([buyString isEqualToString:@"UN_CONFIRMED"]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeFourStamp isEqualToString:@"0"]) {
                            [weakSelf.buyReceiveArray removeAllObjects];
                            [weakSelf.buyReceiveArray addObjectsFromArray:allArray];
                            weakSelf.timeFourStamp = dic[@"latest"];
                        } else {
                            [weakSelf.buyReceiveArray addObjectsFromArray:allArray];
                            weakSelf.timeFourStamp = dic[@"latest"];
                        }
                    }
                    SHLog(@"%@", weakSelf.buyReceiveArray)
                    [weakSelf handleTableViewEndRefresh:type withTableView:weakSelf.fourthTableView];
                    [weakSelf.fourthTableView reloadData];
                } else if ([buyString isEqualToString:@"UN_EVALUATION"]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeFiveStamp isEqualToString:@"0"]) {
                            [weakSelf.buyEvalArray removeAllObjects];
                            [weakSelf.buyEvalArray addObjectsFromArray:allArray];
                            weakSelf.timeFiveStamp = dic[@"latest"];
                        } else {
                            [weakSelf.buyEvalArray addObjectsFromArray:allArray];
                            weakSelf.timeFiveStamp = dic[@"latest"];
                        }
                    }
                    
                    [weakSelf.fifthTableView reloadData];
                    
                }
            }
            else if (buyOrSell == SHSellGoodsType) {
                if ([buyString isEqualToString:@""]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeSellStamp isEqualToString:@"0"]) {
                            [weakSelf.sellArray removeAllObjects];
                            [weakSelf.sellArray addObjectsFromArray:allArray];
                            weakSelf.timeSellStamp = dic[@"latest"];
                        } else {
                            [weakSelf.sellArray addObjectsFromArray:allArray];
                            weakSelf.timeSellStamp = dic[@"latest"];
                        }
                    }
                    [weakSelf.sellFirstTableView reloadData];
                } else if ([buyString isEqualToString:@"RECEIVE"]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeSendStamp isEqualToString:@"0"]) {
                            [weakSelf.sellSendArray removeAllObjects];
                            [weakSelf.sellSendArray addObjectsFromArray:allArray];
                            weakSelf.timeSendStamp = dic[@"latest"];
                        } else {
                            [weakSelf.sellSendArray addObjectsFromArray:allArray];
                            weakSelf.timeSendStamp = dic[@"latest"];
                        }
                    }
                    [weakSelf.sellSecTabView reloadData];
                } else if ([buyString isEqualToString:@"UN_CONFIRMED"]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeReceiveStamp isEqualToString:@"0"]) {
                            [weakSelf.sellReceiveArray removeAllObjects];
                            [weakSelf.sellReceiveArray addObjectsFromArray:allArray];
                            weakSelf.timeReceiveStamp = dic[@"latest"];
                        } else {
                            [weakSelf.sellReceiveArray addObjectsFromArray:allArray];
                            weakSelf.timeReceiveStamp = dic[@"latest"];
                        }
                    }
                    [weakSelf.sellThirdTabView reloadData];
                } else if ([buyString isEqualToString:@"UN_EVALUATION"]) {
                    if (allArray.count > 0) {
                        if ([weakSelf.timeEvalStamp isEqualToString:@"0"]) {
                            [weakSelf.sellEvalArray removeAllObjects];
                            [weakSelf.sellEvalArray addObjectsFromArray:allArray];
                            weakSelf.timeEvalStamp = dic[@"latest"];
                        } else {
                            [weakSelf.sellEvalArray addObjectsFromArray:allArray];
                            weakSelf.timeEvalStamp = dic[@"latest"];
                        }
                    }
                    [weakSelf.sellForTabView reloadData];
                }
            }
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//上拉加载刷新
- (void)handleTableViewEndRefresh:(SHRefreshUpAndDownType)actionType withTableView:(UITableView *)tableView
{
    if (actionType == SHUpLoadingType) {
        [tableView.mj_footer endRefreshing];
    } else if (actionType == SHDownLoadingType) {
        [tableView.mj_header endRefreshing];
    }
}

#pragma mark ------ tableView的delegate和datasouce
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.firstTableView) {
        return self.buyArray.count;
    } else if (tableView == self.secondTableView) {
        return self.buyPayArray.count;
    } else if (tableView == self.thirdTableView) {
        return self.buySendArray.count;
    } else if (tableView == self.fourthTableView) {
        return self.buyReceiveArray.count;
    } else if (tableView == self.fifthTableView) {
        return self.buyEvalArray.count;
    } else if (tableView == self.sellFirstTableView) {
        SHLog(@"个数")
        SHLog(@"%d", self.sellArray.count)
        if (self.sellArray.count > 0) {
            self.nodataLabel.hidden = YES;
        }
        return self.sellArray.count;
    } else if (tableView == self.sellSecTabView) {
        return self.sellSendArray.count;
    } else if (tableView == self.sellThirdTabView) {
        return self.sellReceiveArray.count;
    } else if (tableView == self.sellForTabView) {
        return self.sellEvalArray.count;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 10)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SHOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    if (tableView == self.firstTableView) {
        SHOrderListModel *model = self.buyArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.secondTableView) {
        SHOrderListModel *model = self.buyPayArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.thirdTableView) {
        SHOrderListModel *model = self.buySendArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.fourthTableView) {
        SHOrderListModel *model = self.buyReceiveArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.fifthTableView) {
        SHOrderListModel *model = self.buyEvalArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.sellFirstTableView) {
        SHOrderListModel *model = self.sellArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.sellSecTabView) {
        SHOrderListModel *model = self.sellSendArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.sellThirdTabView) {
        SHOrderListModel *model = self.sellReceiveArray[indexPath.section];
        [cell setListModel:model];
    } else if (tableView == self.sellForTabView) {
        SHOrderListModel *model = self.sellEvalArray[indexPath.section];
        [cell setListModel:model];
    }
    

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHMyOrderDetailVController *vc = [[SHMyOrderDetailVController alloc] init];
    SHAdDetailViewController *adVC = [[SHAdDetailViewController alloc] init];
    vc.inType = SHOrderListPushType;
    if (tableView == self.firstTableView) {
        SHOrderListModel *model = self.buyArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else if (tableView == self.secondTableView) {
        SHOrderListModel *model = self.buyPayArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tableView == self.thirdTableView) {
        SHOrderListModel *model = self.buySendArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tableView == self.fourthTableView) {
        SHOrderListModel *model = self.buyReceiveArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tableView == self.fifthTableView) {
        SHOrderListModel *model = self.buyEvalArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tableView == self.sellFirstTableView) {
        SHOrderListModel *model = self.sellArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tableView == self.sellSecTabView) {
        SHOrderListModel *model = self.sellSendArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tableView == self.sellThirdTabView) {
        SHOrderListModel *model = self.sellReceiveArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (tableView == self.sellForTabView) {
        SHOrderListModel *model = self.sellEvalArray[indexPath.section];
        if ([model.orderProductType isEqualToString:@"ad"]) {
            adVC.adModel = model;
            [self.navigationController pushViewController:adVC animated:YES];
        } else {
            vc.listModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

/**
 *  买入\卖出
 */
- (void)buyInButtonClick:(UIButton *)button
{
    if (button.tag == _tempBuyBtn.tag) {
        
    } else {
        [_tempBuyBtn setBackgroundColor:SHColorFromHex(0xEBEBF1)];
        [button setBackgroundColor:navColor];
        _tempBuyBtn = button;
        
        
    }
    SHLog(@"%d", _tempBuyBtn.tag)
    [self showTableViewWithButton:button];
    
    if (_tempBuyBtn.tag == 1) {
        [self clickBuyButtonShowNodataLabel:_tempBtn];
    } else if (_tempBuyBtn.tag == 2) {
        [self clickButtonShowSellNodataLabel:_tempSellBtn];
    }
}


- (void)showTableViewWithButton:(UIButton *)btn
{
    if (btn.tag == 1) {
        //显示买入
        self.sellBtn1.hidden = YES;
        self.sellBtn2.hidden = YES;
        self.sellBtn3.hidden = YES;
        self.sellBtn4.hidden = YES;
        self.sellBottomView.hidden = YES;
        self.sellFirstTableView.hidden = YES;
        self.sellSecTabView.hidden = YES;
        self.sellThirdTabView.hidden = YES;
        self.sellForTabView.hidden = YES;
        self.sellBackGroundScr.hidden = YES;
        
        self.btn1.hidden = NO;
        self.btn2.hidden = NO;
        self.btn3.hidden = NO;
        self.btn4.hidden = NO;
        self.btn5.hidden = NO;
        self.navBottomView.hidden = NO;
        self.firstTableView.hidden = NO;
        self.secondTableView.hidden = NO;
        self.thirdTableView.hidden = NO;
        self.fourthTableView.hidden = NO;
        self.fifthTableView.hidden = NO;
        self.backGroundScr.hidden = NO;
    } else if (btn.tag == 2) {
        //显示卖出
        self.sellBtn1.hidden = NO;
        self.sellBtn2.hidden = NO;
        self.sellBtn3.hidden = NO;
        self.sellBtn4.hidden = NO;
        self.sellBottomView.hidden = NO;
        self.sellFirstTableView.hidden = NO;
        self.sellSecTabView.hidden = NO;
        self.sellThirdTabView.hidden = NO;
        self.sellForTabView.hidden = NO;
        self.sellBackGroundScr.hidden = NO;
        
        self.btn1.hidden = YES;
        self.btn2.hidden = YES;
        self.btn3.hidden = YES;
        self.btn4.hidden = YES;
        self.btn5.hidden = YES;
        self.navBottomView.hidden = YES;
        self.firstTableView.hidden = YES;
        self.secondTableView.hidden = YES;
        self.thirdTableView.hidden = YES;
        self.fourthTableView.hidden = YES;
        self.fifthTableView.hidden = YES;
        self.backGroundScr.hidden = YES;
    }
    
}



#pragma mark - btn的绑定方法
- (void)btnClick:(UIButton *)sender
{
    SHLog(@"点击了----%ld", sender.tag)
    //点击btn的时候scrollview的contentSize发生变化
    [self.backGroundScr setContentOffset:CGPointMake((sender.tag-10) * SHScreenW, 0) animated:YES];
    
    if (sender.tag == _tempBtn.tag) {
        
    } else {
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:navColor forState:UIControlStateNormal];
        _tempBtn = sender;
    }
    
    //btn下方的下划线滑动
    [UIView animateWithDuration:0.2 animations:^{
        self.navBottomView.frame = CGRectMake(25 + (sender.tag - 10) * ((SHScreenW - 25 * 6) / 5 + 25), 48, (SHScreenW - 25 * 6) / 5, 2);
    }];
    
    
    //判断消费页面数据显示有无数据的label
    [self clickBuyButtonShowNodataLabel:sender];
    
}

- (void)sellBtnClick:(UIButton *)sender
{
    SHLog(@"收入---%d", sender.tag)
    //点击btn的时候scrollview的contentSize发生变化
    [self.sellBackGroundScr setContentOffset:CGPointMake((sender.tag-20) * SHScreenW, 0) animated:YES];
    
    if (sender.tag == _tempSellBtn.tag) {
        
    } else {
        [_tempSellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:navColor forState:UIControlStateNormal];
        _tempSellBtn = sender;
    }
    
    //btn下方的下划线滑动
    [UIView animateWithDuration:0.2 animations:^{
        self.sellBottomView.frame = CGRectMake(25 + (sender.tag - 20) * ((SHScreenW - 25 * 5) / 4 + 25), 48, (SHScreenW - 25 * 5) / 4, 2);
    }];
    
    
    [self clickButtonShowSellNodataLabel:sender];
    
}

//买入
- (void)clickBuyButtonShowNodataLabel:(UIButton *)sender
{
    if (sender.tag - 10 == 0) {
        if (self.buyArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    } else if (sender.tag - 10 == 1) {
        if (self.buyPayArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    } else if (sender.tag - 10 == 2) {
        if (self.buySendArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    } else if (sender.tag - 10 == 3) {
        if (self.buyReceiveArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    } else if (sender.tag - 10 == 4) {
        if (self.buyEvalArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    }
}

//卖出
- (void)clickButtonShowSellNodataLabel:(UIButton *)sender
{
    if (sender.tag - 20 == 0) {
        if (self.sellArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    } else if (sender.tag - 20 == 1) {
        if (self.sellSendArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    } else if (sender.tag - 20 == 2) {
        if (self.sellReceiveArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    } else if (sender.tag - 20 == 3) {
        if (self.sellEvalArray.count == 0) {
            self.nodataLabel.hidden = NO;
            [self.view bringSubviewToFront:self.nodataLabel];
        } else {
            self.nodataLabel.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
