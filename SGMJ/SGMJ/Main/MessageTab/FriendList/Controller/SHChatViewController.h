//
//  SHChatViewController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "EaseMessageViewController.h"
//#if DEMO_CALL == 1

@interface SHChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (nonatomic, strong) NSString *chatWay;//1,圈聊，0 私信

@property (nonatomic, weak) id <EaseMessageViewControllerDelegate> delegate;
@property (nonatomic, weak) id <EaseMessageViewControllerDataSource> dataSource;

@property (nonatomic, copy) NSString *phone;

@end
