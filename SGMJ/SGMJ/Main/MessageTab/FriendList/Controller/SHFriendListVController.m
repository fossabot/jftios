//
//  SHFriendListVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/22.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHFriendListVController.h"
#import "SHChatViewController.h"
#import "SHFriendModel.h"
#import "SHFriendTableViewCell.h"


static NSString *identityCell = @"SHFriendTableViewCell";

@interface SHFriendListVController () <UITableViewDelegate, UITableViewDataSource, EMContactManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *noDataButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation SHFriendListVController

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
    
    [self loadListData];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"好友列表";
    
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
}


- (void)loadListData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMyFriendListUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (code == 0) {
            _tableView.hidden = NO;
            [self.dataArray removeAllObjects];
            NSMutableArray *array = [SHFriendModel mj_objectArrayWithKeyValuesArray:JSON[@"list"]];
            if (array.count == 0) {
                _tableView.hidden = YES;
            } else {
                _tableView.hidden = NO;
                [self.dataArray addObjectsFromArray:array];
                [_tableView reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        _tableView.hidden = YES;
    }];
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
    SHFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
    SHFriendModel *model = self.dataArray[indexPath.row];
    [cell.headImageV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    cell.headImageV.layer.cornerRadius = cell.headImageV.height / 2;
    cell.headImageV.clipsToBounds = YES;
    cell.nameLabel.text = model.nickName;
    cell.introduceL.text = model.introduce;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHFriendModel *model = self.dataArray[indexPath.row];
    
    //创建聊天回话，传递用户或者群id和回话类型（EMConversationType）
    SHChatViewController *vc = [[SHChatViewController alloc] initWithConversationChatter:model.mobile conversationType:EMConversationTypeChat];
    vc.title = model.nickName;
    vc.phone = model.mobile;
    [self.navigationController pushViewController:vc animated:YES];
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
