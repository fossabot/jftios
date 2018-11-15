//
//  SHListViewController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/17.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "EaseConversationListViewController.h"

@interface SHListViewController : EaseConversationListViewController <EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource, EMChatManagerDelegate>

@property (nonatomic, weak) id<EaseConversationListViewControllerDelegate> delegate;
@property (nonatomic, weak) id<EaseConversationListViewControllerDataSource> dataSource;

@property (strong, nonatomic) NSMutableArray *conversationsArray;
- (void)refresh;
- (void)refreshDataSource;
- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
-(void)setupUnreadMessageCount;
@end
