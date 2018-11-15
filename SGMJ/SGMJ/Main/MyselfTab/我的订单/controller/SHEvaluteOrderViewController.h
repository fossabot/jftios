//
//  SHEvaluteOrderViewController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/5.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"

typedef void(^SHModifyEvaluateBlock)(NSUInteger accessId);

@interface SHEvaluteOrderViewController : ViewController




@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, assign) NSUInteger accessId;

@property (nonatomic, assign) SHEvaluateIntoType evaluateType;


@property (nonatomic, copy) SHModifyEvaluateBlock evaluateBlock;

@end
