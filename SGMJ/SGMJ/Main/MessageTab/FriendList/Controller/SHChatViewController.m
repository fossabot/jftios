//
//  SHChatViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHChatViewController.h"
#import "DemoCallManager.h"
#import "EMCallViewController.h"



@interface SHChatViewController () <EMCallManagerDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSObject *callLock;
@property (strong, nonatomic) EMCallSession *currentSession;
@property (strong, nonatomic) EMCallViewController *currentController;

//@property (nonatomic, strong) CTCallCenter *callCenter;
@end


@implementation SHChatViewController



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    self.dataSource = self;
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
    
    [self checkIsFridend];
}

- (void)checkIsFridend
{
    
    if (_phone) {
        SHWeakSelf
        SHLog(@"存在phone")
        NSDictionary *dic = @{
                              @"mobile":_phone
                              };
        SHLog(@"%@", dic)
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHCheckIsMyFriendUrl params:dic success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", msg)
            SHLog(@"%@", JSON)
            if (code == 0) {
                if ([JSON[@"flag"] integerValue] == 0) {            //好友关系
                    [weakSelf showIsFriend];
                } else if ([JSON[@"flag"] integerValue] == 1) {     //非好友关系
                    
                }
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        SHLog(@"不存在phone")
    }
    
}

- (void)showIsFriend
{
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStyleDone target:self action:@selector(addFriend)];
    [barBut setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barBut;
    
    
}

- (void)addFriend
{
    //添加好友
    EMError *error = [[EMClient sharedClient].contactManager addContact:_phone message:@"我想加您为好友"];
    if (!error) {
        SHLog(@"添加成功")
        [MBProgressHUD showMBPAlertView:@"好友请求添加成功" withSecond:2.0];
    }
    
}



- (void)sendMessage:(EMMessage *)message isNeedUploadFile:(BOOL)isUploadFile
{
    
    if (self.conversation.type == EMConversationTypeGroupChat) {
        message.chatType = EMChatTypeGroupChat;
    } else if (self.conversation.type == EMConversationTypeChatRoom) {
        message.chatType = EMChatTypeChatRoom;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:Key_avatar] != nil && [defaults objectForKey:Key_nickName] != nil){
        
        NSDictionary *exit = @{@"avatar":[defaults objectForKey:Key_avatar],@"nickname":[defaults objectForKey:Key_nickName]};
        if(message.ext != nil){
            
        }else{
            message.ext = exit;
        }
    }
    
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        if (weakself.dataSource && [weakself.dataSource respondsToSelector:@selector(messageViewController:updateProgress:messageModel:messageBody:)]) {
            [weakself.dataSource messageViewController:weakself updateProgress:progress messageModel:nil messageBody:message.body];
        }
    } completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            
            //[weakself _refreshAfterSentMessage:aMessage];
            
        }
        else {
            [weakself.tableView reloadData];
        }
    }];
    
    
}

#pragma mark - EaseMessageViewControllerDataSource
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    
    /*
     *  1.从本地获取头像昵称
     *  2.在此处赋值即可
     */
    
    if (model.isSender) {//自己发送
        
        model.message.ext = @{@"avatar":SH_AppDelegate.personInfo.avatar,@"nickname":SH_AppDelegate.personInfo.nickName,@"hxid":SH_AppDelegate.personInfo.mobile};
        //头像
        model.avatarURLPath = SH_AppDelegate.personInfo.avatar;
        //昵称
        model.nickname = SH_AppDelegate.personInfo.nickName;
        //头像占位图
        model.avatarImage = [UIImage imageNamed:@"defaultHead"];
        
        
    }else{//对方发送
        //头像占位图
        model.avatarImage = [UIImage imageNamed:@"defaultHead"];
        //头像
        model.avatarURLPath = message.ext[@"avatar"];
        //昵称
        model.nickname =  message.ext[@"nickname"];
        
    }
    
    model.failImageName = @"defaultHead";
    return model;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
