//
//  SHFriendListTableViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHFriendListTableViewController.h"
#import "SHFriendTableViewCell.h"
#import "SHChatViewController.h"
#import "SHFriendModel.h"

static NSString *identityCell = @"SHFriendTableViewCell";
@interface SHFriendListTableViewController () <EMContactManagerDelegate>
{
    NSMutableArray *_nameArr;
}

@end

@implementation SHFriendListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self loadListData];
}

- (void)initBaseInfo
{
    self.title = @"好友列表";
    _nameArr = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self getFriendListAndReloadTableView];
    
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
            [_nameArr removeAllObjects];
            NSMutableArray *array = [SHFriendModel mj_objectArrayWithKeyValuesArray:JSON[@"list"]];
            if (array.count == 0) {
                
            }
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}


/**
 *  获取好友列表并刷新tableView
 */
- (void)getFriendListAndReloadTableView
{
    //获取好友列表
    EMError *error = nil;
    NSArray *userList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        SHLog(@"好友获取成功 -- %@", userList)
        [_nameArr removeAllObjects];
        [_nameArr addObjectsFromArray:userList];
        [self.tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - EMContactManagerDelegate 监听添加好友回调
/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *
 *  \~english
 *  User A will receive this callback after user B requested to add user A as a friend
 *
 *  @param aUsername   User B
 *  @param aMessage    Friend invitation message
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage __deprecated_msg("Use -friendRequestDidReceiveFromUser:message:")
{
    SHLog(@"aMessage:%@", aMessage)
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到来自%@的请求", aUsername] message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //同意好友添加的方法
        EMError *agreeError = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!agreeError) {
            SHLog(@"发送同意成功")
            //获取好友列表并刷新tableView
            [self getFriendListAndReloadTableView];
        } else {
            SHLog(@"同意添加好友失败")
        }
    }];
    
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //拒绝好友请求的方法
        EMError *rejectError = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!rejectError) {
            SHLog(@"发送拒绝添加好友成功")
        } else {
            SHLog(@"拒绝添加好友失败")
        }
        
    }];
    
    [alertCon addAction:acceptAction];
    [alertCon addAction:rejectAction];
    [self showDetailViewController:alertCon sender:nil];
}

- (void)friendRequestDidApproveByUser:(NSString *)aUsername
{
    SHLog(@"同意添加了aUsername:%@", aUsername)
    //发出推送，同意添加好友了
    
    //获取好友列表，刷新tableView
    [self getFriendListAndReloadTableView];
}

- (void)friendRequestDidDeclineByUser:(NSString *)aUsername
{
    SHLog(@"%@拒绝了我的好友添加请求", aUsername)
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArr.count;
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
    
    cell.nameLabel.text = _nameArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //创建聊天回话，传递用户或者群id和回话类型（EMConversationType）
    SHChatViewController *vc = [[SHChatViewController alloc] initWithConversationChatter:_nameArr[indexPath.row] conversationType:EMConversationTypeChat];
    vc.title = _nameArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}















@end
