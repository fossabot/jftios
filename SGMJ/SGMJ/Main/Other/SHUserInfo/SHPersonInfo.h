//
//  SHPersonInfo.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/9.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    sSH_personSexTypeMan        = 0,    //男
    sSH_personSexTypeWoman      = 1     //女
}SH_PersonSexType;

@interface SHPersonInfo : NSObject

+ (instancetype)sharedPersonInfo;

@property (nonatomic, assign) NSInteger isLogin;



//registerID
@property (nonatomic, copy) NSString *registerID;

//地址
@property (nonatomic, copy) NSString *address;
//bannerUrl
@property (nonatomic, copy) NSString *bannerUrl;
//cardBehindUrl
@property (nonatomic, copy) NSString *cardBehindUrl;
//cardFrontUrl
@property (nonatomic, copy) NSString *cardFrontUrl;
//iDCard
@property (nonatomic, assign) NSInteger iDCard;
//type
@property (nonatomic, assign) NSInteger type;           //1.普通用户    2.服务用户
//isVerified
@property (nonatomic, assign) NSInteger isVerified;     //0.默认，1.申请中的状态，2.成功，3.失败
//level
@property (nonatomic, assign) NSInteger level;
//用户id
@property (nonatomic, assign) NSInteger userId;
//用户头像地址avatar
@property (nonatomic, copy) NSString *avatar;
//用户生日birthday
@property (nonatomic, copy) NSString *birthday;
//用户性别gender
@property (nonatomic, assign) SH_PersonSexType sex;
//电话mobile
@property (nonatomic, assign) NSString *mobile;
//介绍introduce
@property (nonatomic, copy) NSString *introduce;
//昵称nickName
@property (nonatomic, copy) NSString *nickName;
//密码password
@property (nonatomic, copy) NSString *password;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//用户姓名
@property (nonatomic, copy) NSString *userName;
//用户所在的城市
@property (nonatomic, copy) NSString *city;
//用户的经度信息
@property (nonatomic, assign) double longitude;
//用户的维度信息
@property (nonatomic, assign) double latitude;

//用户零钱余额
@property (nonatomic, assign) double balance;

//用户红包余额
@property (nonatomic, assign) double redCash;

//音量
@property (nonatomic, assign) double volume;

//待付款
@property (nonatomic, assign) NSInteger waitPayNum;
//待服务
@property (nonatomic, assign) NSInteger waitSerNum;
//待确认
@property (nonatomic, assign) NSInteger waitSureNum;
//待评价
@property (nonatomic, assign) NSInteger waitEvaNum;


//int数据类型转化为男女性别
- (NSString *)getSexText:(SH_PersonSexType)sh_personSexType;

/**
 *  注销登录
 */
- (void)resignLogin;



@end
