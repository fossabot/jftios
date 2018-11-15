//
//  SHNeedDetailVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHNeedDetailVController.h"
#import "SHNeedDetailModel.h"
#import "SHReportPriceVController.h"
#import "SHReportPriceModel.h"
#import "SHNoDataTableViewFooter.h"

#import "SHReportPriceCell.h"
#import "SHReportPriceModel.h"


static NSString *identityCell = @"SHReportPriceCell";
@interface SHNeedDetailVController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UIImageView *authImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgV;
@property (weak, nonatomic) IBOutlet UILabel *leftDaysL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *forcastL;
@property (weak, nonatomic) IBOutlet UILabel *serviceRouL;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *nodataL;
@property (nonatomic, strong) NSString *earliest;
@property (nonatomic, strong) NSString *latest;

@property (nonatomic, strong) SHNeedDetailModel *detailModel;

@end

@implementation SHNeedDetailVController


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


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    [self loadDetailData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDetailData) name:@"refreshDetail" object:nil];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"需求详情";
    
    _reportButton.backgroundColor = [navColor colorWithAlphaComponent:0.7f];
    _reportButton.layer.cornerRadius = _reportButton.height / 2;
    _reportButton.clipsToBounds = YES;
    
    [_tableView registerClass:[SHReportPriceCell class] forCellReuseIdentifier:identityCell];
    
}

- (void)loadDetailData
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"needId":@(self.needId)
                          };
    SHLog(@"%@", dic)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHNeedDetailUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self.dataArray removeAllObjects];
        if (code == 0) {
            _detailModel = [SHNeedDetailModel mj_objectWithKeyValues:JSON[@"need"]];
            [weakSelf initBaseInfoWithModel:_detailModel];
            NSDictionary *dic = JSON[@"need"];
            self.dataArray = [SHReportPriceModel mj_objectArrayWithKeyValuesArray:_detailModel.offerList];
            
//            SHLog(@"%@", array)
//            SHLog(@"%d", array.count)
            if (self.dataArray.count == 0) {
                _nodataL.hidden = NO;
            } else {
                _nodataL.hidden = YES;
            }
            
            [self.tableView reloadData];
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)initBaseInfoWithModel:(SHNeedDetailModel *)model
{
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:model.needUserAvatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nameL.text = model.needUserNickName;
    SHLog(@"%d", model.status)
    //状态 0竞价中 1服务进行中 2已完成 3 退款 4 超时 5 弃标
    if (model.status == 0) {
        _statusImgV.image = [UIImage imageNamed:@"beingBidding"];
        _statusL.text = @"竞价中";
    } else if (model.status == 1) {
        _statusImgV.image = [UIImage imageNamed:@"serviceing"];
        _statusL.text = @"服务进行中";
    } else if (model.status == 2) {
        _statusImgV.image = [UIImage imageNamed:@"haveDone"];
        _statusL.text = @"已完成";
    } else if (model.status == 3) {
        _statusImgV.image = [UIImage imageNamed:@"beingBidding"];
        _statusL.text = @"退款";
    } else if (model.status == 4) {
        _statusImgV.image = [UIImage imageNamed:@"haveCancel"];
        _statusL.text = @"超时";
    } else if (model.status == 5) {
        _statusImgV.image = [UIImage imageNamed:@"haveCancel"];
        _statusL.text = @"弃标";
    }
    _leftDaysL.text = [NSString stringWithFormat:@"剩余：%d天", model.leftDays];
    _titleL.text = [NSString stringWithFormat:@"标题：%@", model.title];
    _contentL.text = [NSString stringWithFormat:@"要求：%@", model.content];
    _addressL.text = [NSString stringWithFormat:@"地址：%@", model.address];
    _forcastL.text = [NSString stringWithFormat:@"预算：%.2f元", model.money];
    _serviceRouL.text = [NSString stringWithFormat:@"服务周期：%d天", model.timePeriod];
    
    NSString *service = [NSString stringWithFormat:@"%d天", model.timePeriod];
    NSMutableAttributedString *serString = [[NSMutableAttributedString alloc] initWithString:_serviceRouL.text];
    NSRange range1 = [[serString string] rangeOfString:service];
    [serString addAttribute:NSForegroundColorAttributeName value:SHColorFromHex(0xf5ac5d) range:range1];
    _serviceRouL.attributedText = serString;
    
    NSString *foreString = @"预算：";
    NSString *foreRightStr = [NSString stringWithFormat:@"%.2f元", model.money];
    _forcastL.text = [NSString stringWithFormat:@"%@%@", foreString, foreRightStr];
    NSMutableAttributedString *forecastString = [[NSMutableAttributedString alloc] initWithString:_forcastL.text];
    NSRange range2 = [[forecastString string] rangeOfString:foreRightStr];
    [forecastString addAttribute:NSForegroundColorAttributeName value:SHColorFromHex(0xf5ac5d) range:range2];
    _forcastL.attributedText = forecastString;
    
    
    
    //0是 1否 是否是自己查看
    if (model.isMyself == 0) {
        _reportButton.hidden = NO;
    } else if (model.isMyself == 1) {
        _reportButton.hidden = YES;
    }
    
    //报价列表
    if (model.offerList.count == 0) {
        //显示无数据
        
    } else {
        //展示数据
        
    }
    
    if (model.isMyself == 1 && model.status == 0) {
        _reportButton.hidden = NO;
    } else {
        _reportButton.hidden = YES;
    }
    
    
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
        SHLog(@"存在了脚视图")
        return;
    }
    
    
}

//移除footer的处理
- (void)removeFooter
{
    [self.tableView.mj_footer removeFromSuperview];
    self.tableView.mj_footer = nil;
}

//无数据处理
- (void)handleFooter
{
    if (self.dataArray.count == 0) {
        SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
        self.tableView.tableFooterView = footer;
    } else {
        [self removeFooter];
    }
}

//报价
- (IBAction)reportPriceButtonClick:(UIButton *)sender {
    
    SHReportPriceVController *vc = [[SHReportPriceVController alloc] init];
    vc.needId = self.needId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHReportPriceModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHReportPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHReportPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    SHReportPriceModel *model = self.dataArray[indexPath.row];
    cell.isMyself = _detailModel.isMyself;
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
