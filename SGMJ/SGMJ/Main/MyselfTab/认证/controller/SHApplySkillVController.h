//
//  SHApplySkillVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"

@class SHMySkillModel;


@class SHMyOrderDetailModel;

typedef void(^SHDoneServiceOrderBlock)(NSString *orderNo);


@protocol SHOrderDoneDelegate <NSObject>

- (void)orderMakeSureDone;


@end

@interface SHApplySkillVController : ViewController



@property (nonatomic, strong) SHMySkillModel *model;

//@property (nonatomic, strong) SHMyOrderDetailModel *detailModel;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, assign) SHOrderAndSkillApplyType type;



@property (nonatomic, copy) SHDoneServiceOrderBlock orderDoneBlock;

@property (nonatomic, weak) id<SHOrderDoneDelegate> orderDoneDelegate;


@property (nonatomic, assign) SHPushOrderDetailType intype;

@end







