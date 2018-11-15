//
//  SHPersonInfo.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/9.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPersonInfo.h"

@implementation SHPersonInfo

+ (instancetype)sharedPersonInfo
{
    static SHPersonInfo *personInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        personInfo = [[SHPersonInfo alloc] init];
    });
    return personInfo;
}

- (id)init
{
    self = [super init];
    if (self) {
        _waitEvaNum = [SH_UserDefaults integerForKey:Key_waitEvaNum];
        _waitSureNum = [SH_UserDefaults integerForKey:Key_waitSureNum];
        _waitSerNum = [SH_UserDefaults integerForKey:Key_waitSerNum];
        _waitPayNum = [SH_UserDefaults integerForKey:Key_waitPayNum];
        _volume = [SH_UserDefaults doubleForKey:Key_Volume];
        _registerID = [SH_UserDefaults objectForKey:Key_registerID];
        _address = [SH_UserDefaults objectForKey:Key_address];
        _bannerUrl  = [SH_UserDefaults objectForKey:Key_bannerUrl];
        _cardBehindUrl = [SH_UserDefaults objectForKey:Key_cardBehindUrl];
        _cardFrontUrl = [SH_UserDefaults objectForKey:Key_cardFrontUrl];
        _iDCard = [SH_UserDefaults integerForKey:Key_iDCard];
        _isVerified = [SH_UserDefaults integerForKey:Key_isVerified];
        _level = [SH_UserDefaults integerForKey:Key_level];
        _type = [SH_UserDefaults integerForKey:Key_type];
        
        _isLogin = [SH_UserDefaults integerForKey:Key_isLogin];
        _userId = [SH_UserDefaults integerForKey:Key_userId];
        _avatar = [SH_UserDefaults objectForKey:Key_avatar];
        _nickName = [SH_UserDefaults objectForKey:Key_nickName];
        _mobile = [SH_UserDefaults objectForKey:Key_mobile];
        _introduce = [SH_UserDefaults objectForKey:Key_introduce];
        _sex = [SH_UserDefaults integerForKey:Key_gender];
        _birthday = [SH_UserDefaults objectForKey:Key_birthday];
        _password = [SH_UserDefaults objectForKey:Key_password];
        _longitude = [SH_UserDefaults doubleForKey:Key_longitude];
        _latitude = [SH_UserDefaults doubleForKey:Key_latitude];
        _city = [SH_UserDefaults objectForKey:Key_city];
        _realName = [SH_UserDefaults objectForKey:Key_realName];
        _balance = [SH_UserDefaults doubleForKey:Key_balance];
        _redCash = [SH_UserDefaults doubleForKey:Key_RedCrash];
    }
    return self;
}

- (void)setWaitEvaNum:(NSInteger)waitEvaNum
{
    _waitEvaNum = waitEvaNum;
    [SH_UserDefaults setInteger:waitEvaNum forKey:Key_waitEvaNum];
}

- (void)setWaitSureNum:(NSInteger)waitSureNum
{
    _waitSureNum = waitSureNum;
    [SH_UserDefaults setInteger:waitSureNum forKey:Key_waitSureNum];
}

- (void)setWaitSerNum:(NSInteger)waitSerNum
{
    _waitSerNum = waitSerNum;
    [SH_UserDefaults setInteger:waitSerNum forKey:Key_waitSerNum];
}

- (void)setWaitPayNum:(NSInteger)waitPayNum
{
    _waitPayNum = waitPayNum;
    [SH_UserDefaults setInteger:waitPayNum forKey:Key_waitPayNum];
}

- (void)setVolume:(double)volume
{
    _volume = volume;
    [SH_UserDefaults setDouble:volume forKey:Key_Volume];
}

- (void)setRegisterID:(NSString *)registerID
{
    _registerID = registerID;
    [SH_UserDefaults setObject:registerID forKey:Key_registerID];
}

- (void)setAddress:(NSString *)address
{
    _address = address;
    [SH_UserDefaults setObject:address forKey:Key_address];
}

- (void)setBannerUrl:(NSString *)bannerUrl
{
    _bannerUrl = bannerUrl;
    [SH_UserDefaults setObject:bannerUrl forKey:Key_bannerUrl];
}

- (void)setCardBehindUrl:(NSString *)cardBehindUrl
{
    _cardBehindUrl = cardBehindUrl;
    [SH_UserDefaults setObject:cardBehindUrl forKey:Key_cardBehindUrl];
}

- (void)setCardFrontUrl:(NSString *)cardFrontUrl
{
    _cardFrontUrl = cardFrontUrl;
    [SH_UserDefaults setObject:cardFrontUrl forKey:Key_cardFrontUrl];
}

- (void)setIDCard:(NSInteger)iDCard
{
    _iDCard = iDCard;
    [SH_UserDefaults setInteger:iDCard forKey:Key_iDCard];
}

- (void)setIsVerified:(NSInteger)isVerified
{
    _isVerified = isVerified;
    [SH_UserDefaults setInteger:isVerified forKey:Key_isVerified];
}

- (void)setLevel:(NSInteger)level
{
    _level = level;
    [SH_UserDefaults setInteger:level forKey:Key_level];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    [SH_UserDefaults setInteger:type forKey:Key_type];
}


- (void)setIsLogin:(NSInteger)isLogin {
    _isLogin = isLogin;
    [SH_UserDefaults setInteger:isLogin forKey:Key_isLogin];
}

- (void)setUserId:(NSInteger)userId
{
    _userId = userId;
    [SH_UserDefaults setInteger:userId forKey:Key_userId];
    [SH_UserDefaults setInteger:userId forKey:@"USERID"];
}

- (void)setBalance:(double)balance
{
    _balance = balance;
    [SH_UserDefaults setDouble:balance forKey:Key_balance];
}

- (void)setRedCash:(double)redCash
{
    _redCash = redCash;
    [SH_UserDefaults setDouble:redCash forKey:Key_RedCrash];
}

- (void)setAvatar:(NSString *)avatar
{
    _avatar = avatar;
    [SH_UserDefaults setObject:avatar forKey:Key_avatar];
}

- (void)setBirthday:(NSString *)birthday
{
    _birthday = birthday;
    [SH_UserDefaults setObject:birthday forKey:Key_birthday];
}

- (void)setSex:(SH_PersonSexType)sex
{
    _sex = sex;
    [SH_UserDefaults setInteger:sex forKey:Key_gender];
}

- (void)setMobile:(NSString *)mobile
{
    _mobile = mobile;
    [SH_UserDefaults setObject:mobile forKey:Key_mobile];
}

- (void)setIntroduce:(NSString *)introduce
{
    _introduce = introduce;
    [SH_UserDefaults setObject:introduce forKey:Key_introduce];
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    [SH_UserDefaults setObject:nickName forKey:Key_nickName];
}

- (void)setPassword:(NSString *)password
{
    _password = password;
    [SH_UserDefaults setObject:password forKey:Key_password];
}

- (void)setRealName:(NSString *)realName
{
    _realName = realName;
    [SH_UserDefaults setObject:realName forKey:Key_realName];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [SH_UserDefaults setObject:userName forKey:Key_userName];
}

- (void)setCity:(NSString *)city
{
    _city = city;
    [SH_UserDefaults setObject:city forKey:Key_city];
}

- (void)setLongitude:(double)longitude
{
    _longitude = longitude;
    [SH_UserDefaults setDouble:longitude forKey:Key_longitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLatitude:(double)latitude
{
    _latitude = latitude;
    [SH_UserDefaults setDouble:latitude forKey:Key_latitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getSexText:(SH_PersonSexType)sh_personSexType
{
    NSString *tempString = nil;
    switch (sh_personSexType) {
        case sSH_personSexTypeMan:
            tempString = @"男";
            break;
        case sSH_personSexTypeWoman:
            tempString = @"女";
            break;
        default:
            break;
    }

    return tempString;
}

/**
 *  退出登录
 */
- (void)resignLogin
{
    SH_AppDelegate.personInfo.address = nil;
    SH_AppDelegate.personInfo.bannerUrl = nil;
    SH_AppDelegate.personInfo.cardBehindUrl = nil;
    SH_AppDelegate.personInfo.cardFrontUrl = nil;
    SH_AppDelegate.personInfo.iDCard = 0;
    SH_AppDelegate.personInfo.isVerified = 0;
    SH_AppDelegate.personInfo.level = 0;
    SH_AppDelegate.personInfo.type = 0;
    
    
    SH_AppDelegate.personInfo.isLogin = 0;
    SH_AppDelegate.personInfo.userId = 0;
    SH_AppDelegate.personInfo.avatar = nil;
    SH_AppDelegate.personInfo.mobile = nil;
    SH_AppDelegate.personInfo.nickName = nil;
    SH_AppDelegate.personInfo.realName = nil;
    SH_AppDelegate.personInfo.sex = 0;
    SH_AppDelegate.personInfo.birthday = nil;
    SH_AppDelegate.personInfo.introduce = nil;
    SH_AppDelegate.personInfo.userName = nil;
//    SH_AppDelegate.personInfo.longitude = 0;
//    SH_AppDelegate.personInfo.latitude = 0;
    SH_AppDelegate.personInfo.city = @"合肥";
    SH_AppDelegate.personInfo.balance = 0;
    SH_AppDelegate.personInfo.redCash = 0;
    SH_AppDelegate.personInfo.volume = 1.0;
    SH_AppDelegate.personInfo.waitPayNum = 0;
    SH_AppDelegate.personInfo.waitSerNum = 0;
    SH_AppDelegate.personInfo.waitSureNum = 0;
    SH_AppDelegate.personInfo.waitEvaNum = 0;
    
    [SH_UserDefaults removeObjectForKey:Key_address];
    [SH_UserDefaults removeObjectForKey:Key_bannerUrl];
    [SH_UserDefaults removeObjectForKey:Key_cardBehindUrl];
    [SH_UserDefaults removeObjectForKey:Key_cardFrontUrl];
    [SH_UserDefaults removeObjectForKey:Key_iDCard];
    [SH_UserDefaults removeObjectForKey:Key_isVerified];
    [SH_UserDefaults removeObjectForKey:Key_level];
    [SH_UserDefaults removeObjectForKey:Key_type];
    
    [SH_UserDefaults removeObjectForKey:Key_isLogin];
    [SH_UserDefaults removeObjectForKey:Key_userId];
    [SH_UserDefaults removeObjectForKey:Key_avatar];
    [SH_UserDefaults removeObjectForKey:Key_mobile];
    [SH_UserDefaults removeObjectForKey:Key_nickName];
    [SH_UserDefaults removeObjectForKey:Key_realName];
    [SH_UserDefaults removeObjectForKey:Key_gender];
    [SH_UserDefaults removeObjectForKey:Key_birthday];
    [SH_UserDefaults removeObjectForKey:Key_introduce];
    [SH_UserDefaults removeObjectForKey:Key_userName];
    //[SH_UserDefaults removeObjectForKey:Key_longitude];
    //[SH_UserDefaults removeObjectForKey:Key_latitude];
    [SH_UserDefaults removeObjectForKey:Key_city];
    
}




@end
