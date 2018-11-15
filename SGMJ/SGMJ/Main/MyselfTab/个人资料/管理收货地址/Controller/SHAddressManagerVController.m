//
//  SHAddressManagerVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/9.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAddressManagerVController.h"
#import "SHNewAddAddressVController.h"
#import "SHAddressCell.h"
#import "SHAddressModel.h"


static NSString *identityCell = @"SHAddressCell";
@interface SHAddressManagerVController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIView *nodataView;

@end

@implementation SHAddressManagerVController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_dataSource removeAllObjects];
    [self requestAddressList];
}

- (void)initBaseInfo
{
    
    self.navigationItem.title = @"管理收货地址";
    
    _addButton.layer.cornerRadius = _addButton.height / 2;
    _addButton.clipsToBounds = YES;
    
    
    _dataSource = [NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAddressNoti:) name:@"deleteAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyDefaultAddress:) name:@"defaultAddress" object:nil];
    
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestAddressList];
//    }];
//    [_tableView.mj_header beginRefreshing];
    
}

//通知删除
- (void)deleteAddressNoti:(NSNotification *)noti {
    NSDictionary *dic = [noti userInfo];
    NSInteger cellID = [dic[@"addressId"] integerValue];
    for (SHAddressModel *model in _dataSource) {
            if (cellID == model.ID) {
                [_dataSource removeObject:model];
                [MBProgressHUD showMBPAlertView:@"删除成功" withSecond:2.0];
                if (_dataSource.count > 0) {
                    _nodataView.hidden = YES;
                    [_tableView reloadData];
                } else {
                    _nodataView.hidden = NO;
                }
                break;
            }
    }
}

//通知默认地址
- (void)modifyDefaultAddress:(NSNotification *)noti
{
    NSDictionary *dic = [noti userInfo];
    NSInteger cellID = [dic[@"addressId"] integerValue];
    for (SHAddressModel *model in _dataSource) {
        if (cellID == model.ID) {
            [_dataSource removeAllObjects];
            [self requestAddressList];
            break;
        }
    }
}

//地址列表请求
- (void)requestAddressList
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"pageSize":@(10),
                          @"type":@(0),
                          @"current":@(0)
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHAddressListUrl params:dic success:^(id JSON, int code, NSString *msg) {
        
        if (code == 0) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSArray *array = [SHAddressModel mj_objectArrayWithKeyValuesArray:JSON[@"pageResult"][@"res"]];
            if (array.count > 0) {
                _nodataView.hidden = YES;
                if (_dataSource.count > 0) {
                    
                    [_dataSource addObjectsFromArray:array];
                    [_tableView reloadData];
                } else {
                    [_dataSource addObjectsFromArray:array];
                    [_tableView reloadData];
                }
                [_tableView.mj_header endRefreshing];
            } else {
                _nodataView.hidden = NO;
            }
        } else {
            [_tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}


#pragma mark - Action
- (IBAction)addNewAddressButtonClick:(UIButton *)sender {
    SHNewAddAddressVController *Vc = [[SHNewAddAddressVController alloc] init];
    Vc.addressType = SHAddressNewAddType;
    [self.navigationController pushViewController:Vc animated:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];        
    }
    //取消点击效果
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    SHAddressModel *model = _dataSource[indexPath.row];
    cell.tag = model.ID;
    [cell setAddressModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
};
















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
