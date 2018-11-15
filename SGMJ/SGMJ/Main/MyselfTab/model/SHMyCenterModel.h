//
//  SHMyCenterModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMyCenterModel : NSObject



@property (nonatomic, assign) NSUInteger confirmNum;    //待确认
@property (nonatomic, assign) NSUInteger couponNum;     //优惠券
@property (nonatomic, assign) NSUInteger evaluationNum; //待评价
@property (nonatomic, assign) NSUInteger fansNum;       //粉丝
@property (nonatomic, assign) NSUInteger followNum;     //关注
@property (nonatomic, assign) NSUInteger initNum;       //待付款
@property (nonatomic, assign) NSUInteger receiveNum;    //待收货
@property (nonatomic, strong) NSDictionary *user;       //用户
@property (nonatomic, assign) double balance;          //余额



/**
 "user": {
 "address": "",
 "avatar": "http://www.shuhuikeji.com/img/avatar.png",
 "bannerUrl": "",
 "birthday": "2018-07-25 14:41:25",
 "cardBehindUrl": "http://pic.qiantucdn.com/58pic/28/80/94/36c58PIC06ay3M281Hj2Y_PIC2018.png!/fw/120/compress/true/clip/120x160a0a0",
 "cardFrontUrl": "http://pic.qiantucdn.com/58pic/28/80/94/46q58PICWe7hfUBy6bdw8_PIC2018.png!/fw/120/compress/true/clip/120x160a0a0",
 "createTime": "2018-07-25 14:41:20",
 "customerKey": "",
 "gender": 1,
 "iDCard": "340111199503065011",
 "id": "7",
 "introduce": "",
 "isVerified": 1,//是否实名认证
 "level": "",
 "mobile": "18326033700",
 "nickName": "时光马仔",
 "password": "",
 "realName": "李二",
 "type": 1,
 "userName": "18326033700"
 }
 *
 */




@end
