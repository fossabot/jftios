//
//  SHReplayEvaluateVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"


typedef void(^SHReplayRequestBlock)(NSUInteger asseeId);


@interface SHReplayEvaluateVController : ViewController




@property (nonatomic, assign) NSUInteger asseceId;


@property (nonatomic, copy) SHReplayRequestBlock replayBlock;



@end
