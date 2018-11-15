//
//  SHListViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/17.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHListViewController.h"
#import "SHChatViewController.h"
#import "SHMenu.h"
#import "SHAddressBookViewController.h"
#import "SHFriendListTableViewController.h"

#import "SHTabBar.h"
#import "SHMessTableViewCell.h"
#import "SHMessageVController.h"
#import "SHFriendListVController.h"
#import "SHFollowFansViewController.h"

static NSString *identityCell = @"SHMessTableViewCell";
@interface SHListViewController ()
@property (nonatomic, strong) UIView *networkStateView;

@property (nonatomic, strong) UIView *headV;


@end

@implementation SHListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self refresh];
    
    [self refreshAndSortView];
    
    SHLog(@"%@", self.dataArray)
    
//    if (SH_AppDelegate.isPersonLogin) {
//        [self initBaseInfo];
//    } else {
//        SHLog(@"没有登录")
////        self.delegate = nil;
////        self.dataSource = nil;
////        [self.dataArray removeAllObjects];
////        //加载回话列表
////        [self tableViewDidTriggerHeaderRefresh];
//        [self.dataArray removeAllObjects];
//        [self.tableView reloadData];
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //注销代理
    //[[EMClient sharedClient].chatManager removeDelegate:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initBaseInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(huanxinLoginNoti:) name:kNotificationLoginOutHuanXin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(huanxinNoti:) name:@"LoginOutHuanXin" object:nil];
    
}

- (void)initBaseInfo
{
    //刷新
    self.showRefreshHeader = YES;
    //设置代理
    self.delegate = self;
    self.dataSource = self;
    //网络判断
    [self networkStateView];
    
    //加载回话列表
    [self tableViewDidTriggerHeaderRefresh];
    
    //注册代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    SHLog(@"%@", self.dataArray)
    
    //定制右按钮
//    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc] initWithTitle:@"通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(friendList)];
//    [barBut setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//
//    UIImage *image = [UIImage imageNamed:@"messAdd"];
//    //取消渲染
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *twoBarBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAddFunction)];
    //self.navigationItem.rightBarButtonItems = @[twoBarBtn, barBut];
    
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc] initWithTitle:@"好友" style:UIBarButtonItemStylePlain target:self action:@selector(friendListData)];
    [barBut setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0],NSFontAttributeName,SH_TitleColor,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barBut;
    
    [self.tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    
}

/**
 *  好友列表
 */
- (void)friendListData
{
//    SHFriendListVController *vc = [[SHFriendListVController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    SHFollowFansViewController *vc = [[SHFollowFansViewController alloc] init];
    vc.inType = SHGoodFriendTypy;
    vc.checkType = @"FOLLOW";
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  通讯录
 */
- (void)friendList
{
    SHLog(@"好友")
    SHAddressBookViewController *vc = [[SHAddressBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  +
 */
- (void)rightItemAddFunction
{
    //,@"添加好友"
    SHWeakSelf
    [[SHMenu shareManager] showPopMenuSelecteWithFrameWidth:120 height:88 point:CGPointMake(SHScreenW - 25, 5) item:@[@"发起聊天"] imgSource:@[@"beginchat",@"addFriend"] action:^(NSInteger index) {
        SHLog(@"%ld", index)
        if (index == 0) {
            [weakSelf gotoChatListVC];
        } else if (index == 1) {
            [weakSelf gotoFindFriendVC];
        }
    }];
}

/**
 *  发起聊天
 */
- (void)gotoChatListVC
{
    SHLog(@"发起聊天")
    SHFriendListTableViewController *vc = [[SHFriendListTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  添加好友
 */
- (void)gotoFindFriendVC
{
    SHLog(@"添加好友")
    
}


#pragma mark - 通知
- (void)huanxinNoti:(NSNotification *)noti
{
    [self.dataArray removeAllObjects];
    SHLog(@"刷新")
    [self.tableView reloadData];
    
    //[self refreshAndSortView];
}

- (void)huanxinLoginNoti:(NSNotification *)noti
{
    [self tableViewDidTriggerHeaderRefresh];
}

//刷新内存中的消息
- (void)messagesDidReceive:(NSArray *)aMessages
{
    [self refreshAndSortView];
}

#pragma mark - UITableViewDataSource-不同section的行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        SHMessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[SHMessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        return cell;
    }
    NSString *cellIdentitifer = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentitifer];
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentitifer];
    }
    if (self.dataArray.count <= indexPath.row) {
        return cell;
    }
    
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        NSMutableAttributedString *attributedText = [[self.dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =attributedText;
    } else {
        cell.detailLabel.attributedText =[[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [self.dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    //头像的圆角
    cell.avatarView.imageCornerRadius = 20;
    
    return cell;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString*latestMessageTitle =@"";
    
    EMMessage*lastMessage = [conversationModel.conversation latestMessage];
    
    if(lastMessage) {
        
        EMMessageBody*messageBody = lastMessage.body;
        
        switch(messageBody.type) {
                
            case EMMessageBodyTypeImage:{
                
                latestMessageTitle =@"[图片]";
                
            }break;
                
            case EMMessageBodyTypeText:{
                
                //表情映射。
                
                NSString*didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                           
                                           convertToSystemEmoticons:((EMTextMessageBody*)messageBody).text];
                
                latestMessageTitle = didReceiveText;
                
                if([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    
                    latestMessageTitle =@"[动画表情]";
                    
                }
                
            }break;
                
            case EMMessageBodyTypeVoice:{
                
                latestMessageTitle =@"[音频]";
                
            }break;
                
            case EMMessageBodyTypeLocation: {
                
                latestMessageTitle =@"[位置]";
                
            }break;
                
            case EMMessageBodyTypeVideo: {
                
                latestMessageTitle =@"[视频]";
                
            }break;
                
            case EMMessageBodyTypeFile: {
                
                latestMessageTitle =@"[文件]";
                
            }break;
                
            default: {
                
            }break;
                
        }
        
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:latestMessageTitle];
    
    return attStr;
}

//返回传入会话model最近一条消息提示
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}
//获取会话最近一条消息时间
- (NSString *)_latestMessageTimeForConversationModel:(id <IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

#pragma mark - EaseConversationListViewControllerDelegate
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        
        SHChatViewController *chatController = nil;
#ifdef REDPACKET_AVALABLE
        SHLog(@"用户的环信id：%@", conversation.conversationId)
        chatController = [[SHChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#else
        SHLog(@"用户的环信id：%@", conversation.conversationId)
        chatController = [[SHChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#endif
        chatController.title = conversationModel.title;
        chatController.phone = conversation.conversationId;
        [self.navigationController pushViewController:chatController animated:YES];
        //  }
    }
    
    [self.tableView reloadData];
    //   }
}

#pragma mark - EaseConversationListViewControllerDataSource
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        NSDictionary *dic = conversation.lastReceivedMessage.ext;
        SHLog(@"%@", dic)
        model.title = dic[@"nickname"];
        model.avatarURLPath = dic[@"avatar"];
        
        if(dic[@"nickname"] == nil || dic[@"avatar"] == nil){
            SHLog(@"qwer")
            //头像占位图
            model.avatarImage = [UIImage imageNamed:@"defaultHead"];
        }else{
            
            model.title = dic[@"nickname"];
            model.avatarURLPath = dic[@"avatar"];
            //头像占位图
            model.avatarImage = [UIImage imageNamed:@"defaultHead"];
            SHLog(@"asfasdfasdf")
            SHLog(@"用户的环信id：%@", model.conversation.conversationId)
        }
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
        
        //头像占位图--群聊图片
        model.avatarImage = [UIImage imageNamed:@"logo"];
    }
    return model;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return [EaseConversationCell cellHeightWithModel:nil];
}

#pragma mark UITableViewDelegate---点击行单元调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        SHLog(@"消息通知")
        if (indexPath.row == 0) {
            SHMessageVController *vc = [[SHMessageVController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [self.delegate conversationListViewController:self didSelectConversationModel:model];
        } else {
            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            SHLog(@"用户的环信id：%@", model.conversation.conversationId)
            SHChatViewController *viewController = [[SHChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
            
            viewController.title = model.title;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
    
}

#pragma mark --- UITableViewDataSource--删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
        
}


- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
