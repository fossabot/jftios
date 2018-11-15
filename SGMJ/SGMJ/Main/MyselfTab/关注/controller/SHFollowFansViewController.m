//
//  SHFollowFansViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHFollowFansViewController.h"
#import "SHFollowAndFansModel.h"
#import "SHFollowUserModel.h"
#import "SHFollowFanTViewCell.h"
#import "SHNoDataTableViewFooter.h"
#import "SHPersonalViewController.h"
#import "SHChatViewController.h"

static NSString *identityCell = @"SHFollowFanTViewCell";
@interface SHFollowFansViewController () <UITableViewDelegate, UITableViewDataSource, SHFollowAndFansDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *earliest;
@property (nonatomic, strong) NSString *latest;

@end

@implementation SHFollowFansViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    [self loadPeopleListDataWithTimeStamp:@"0" andType:SHInTheFirstTimeType];
    
}

- (void)initBaseInfo
{
    
    if (_inType == SHFollowOtherType) {
        self.navigationItem.title = @"关注";
    } else if (_inType == SHFansPeopleType) {
        self.navigationItem.title = @"粉丝";
    } else if (_inType == SHGoodFriendTypy) {
        self.navigationItem.title = @"好友列表";
    }
    
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    SHWeakSelf
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadPeopleListDataWithTimeStamp:@"0" andType:0];
    }];
    
    
}

- (void)loadPeopleListDataWithTimeStamp:(NSString *)timestamp andType:(SHRefreshUpAndDownType)type
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"checkType":_checkType,
                          @"current":timestamp,
                          @"type":@(type),
                          @"pageSize":@(10)
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHFollowAndFansUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        _tableView.hidden = NO;
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [self endRefresh];
        if (code == 0) {
            NSDictionary *dict = JSON[@"result"];
            self.earliest = dict[@"earliest"];
            self.latest = dict[@"latest"];
            NSMutableArray *array = [SHFollowAndFansModel mj_objectArrayWithKeyValuesArray:dict[@"res"]];
            if (array.count < 10) {
                if (type == 1 || type == 0) {
                    [self removeFooter];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self addFooter];
            }
            
            if (type == 1 || type == 0) {
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self handleFooter];
        }
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
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
        [weakSelf loadPeopleListDataWithTimeStamp:weakSelf.earliest andType:2];
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
    if (self.dataArray.count == 0) {
        SHNoDataTableViewFooter *footer = [SHNoDataTableViewFooter createWithTips:nil];
        self.tableView.tableFooterView = footer;
    }
}




- (IBAction)reloadDataButton:(UIButton *)sender {
    [self loadPeopleListDataWithTimeStamp:@"0" andType:SHInTheFirstTimeType];
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHFollowFanTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHFollowFanTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        
    }
    cell.delegate = self;
    SHFollowAndFansModel *model = self.dataArray[indexPath.row];
    
    if (_inType == SHFollowOtherType) {
        cell.followButton.hidden = NO;
    } else if (_inType == SHFansPeopleType || _inType == SHGoodFriendTypy) {
        cell.followButton.hidden = YES;
    }
    
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_inType == SHFollowOtherType || _inType == SHFansPeopleType) {
        SHPersonalViewController *Vc = [[SHPersonalViewController alloc] init];
        SHFollowAndFansModel *model = self.dataArray[indexPath.row];
        Vc.providerId = model.user.ID;
        [self.navigationController pushViewController:Vc animated:YES];
        
    } else if (_inType == SHGoodFriendTypy) {
        //创建聊天回话，传递用户或者群id和回话类型（EMConversationType）
        SHFollowAndFansModel *model = self.dataArray[indexPath.row];
        SHChatViewController *vc = [[SHChatViewController alloc] initWithConversationChatter:model.user.mobile conversationType:EMConversationTypeChat];
        
        vc.title = model.user.nickName;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

#pragma mark - SHFollowAndFansDelegate
- (void)tellVCloadData
{
    [self loadPeopleListDataWithTimeStamp:@"0" andType:SHInTheFirstTimeType];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
