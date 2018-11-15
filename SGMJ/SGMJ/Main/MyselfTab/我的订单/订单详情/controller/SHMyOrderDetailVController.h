//
//  SHMyOrderDetailVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/1.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"


@class SHOrderListModel;


typedef void(^SHOrderStatuteChangeBlock)(NSString *string);

@interface SHMyOrderDetailVController : ViewController



@property (nonatomic, strong) SHOrderListModel *listModel;


@property (nonatomic, assign) SHPushOrderDetailType inType;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) SHOrderStatuteChangeBlock changeBlock;


@end
