//
//  SHNeedDetailModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/10.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHReportPriceModel;
@interface SHNeedDetailModel : NSObject



@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) NSInteger isFollowed;
@property (nonatomic, assign) NSInteger isMyself;
@property (nonatomic, assign) NSInteger leftDays;
@property (nonatomic, assign) NSInteger timePeriod;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *needUserAvatar;
@property (nonatomic, copy) NSString *needUserMobile;
@property (nonatomic, copy) NSString *needUserNickName;
@property (nonatomic, assign) double money;

@property (nonatomic, strong) NSArray <SHReportPriceModel *> *offerList;



@end
