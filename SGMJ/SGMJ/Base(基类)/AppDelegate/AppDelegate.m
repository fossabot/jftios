//
//  AppDelegate.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/15.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+SHService.h"

#import "ViewController.h"
#import "SH_StartViewController.h"
#import "SHScrollerViewController.h"
#import "SHTabBarController.h"
#import "SHLoginViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <CoreLocation/CoreLocation.h>
#import "SHLocationManager.h"

#import "SHUpdateViewAlert.h"
#import <MapKit/MapKit.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

#import "DemoCallManager.h"
#import "SHTabBarController.h"
#import "ViewController.h"
#import "SH_NavgationViewController.h"
#import "SHKeychainManager.h"

#import "SHMyOrderDetailVController.h"

#import <AVFoundation/AVFoundation.h>
#import "SH_SHSoundPlayer.h"

#import "SHRedPackageV.h"

#import "SHWelfareCenterVController.h"
#import "SHNeedDetailVController.h"

#import "SHTabBarController.h"
#import "SHMessageVController.h"
#import "SHMessageVController.h"

static NSString * const JPUSHAPPKEY = @"48470e29fa94e64042315677"; // 极光appKey
static NSString * const channel = @"Publish channel"; // 固定的
//App Store
#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
#endif

@interface AppDelegate () <CLLocationManagerDelegate, JPUSHRegisterDelegate, WXApiDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) SHLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;

@property (nonatomic, strong) NSDictionary *notDic;
@property (nonatomic, strong) SHTabBarController *sh;

@property (nonatomic, strong) AVSpeechSynthesizer *av;
@property (nonatomic, strong) AVSpeechUtterance *utterance;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _personInfo = [[SHPersonInfo alloc] init];
    _tokenMap = [[SHTokenMap alloc] init];
    _userData = [[SHUserData alloc] init];
    
    _av = [[AVSpeechSynthesizer alloc] init];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    SHLog(@"didFinishLaunchingWithOptions")
    [NSThread sleepForTimeInterval:2.0];//设置启动页面时间
    
    
//    [[DemoCallManager sharedManager] setMainController:sh];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self instantiateRootVC];
    
    [self.window makeKeyAndVisible];
    
    //判断用户是否是首次下载应用
    //[self initUserDownload];
    
    
    
    //方法一           提示更新
//    [SHUpdateViewAlert showUpdateAlertWithVersion:@"1.0.0" descriptArray:@[@"1.xxxxxxxxxx",@"2.xxxxxxxxxxx",@"3.xxxxxxxxxx",@"4.xxxxxxxxxx"]];
    
    //方法二           提示更新
//    [SHUpdateViewAlert showUpdateAlertWithVersion:@"1.0.0" descriptArray:@"1.xxxxxxxxxx\n2.xxxxxxxxxxxxxxxxxxxxxxxxxxxx\n3.xxxxxxxxx\n4.xxxxxxxxxx"];
    
    //获取地理位置
    [self startLocation];
    
    //初始化友盟
    [self initUMengBaseInfo];
    
    //初始化极光推送 1114a89792ffec05cce
    [self initJPushServiceBaseInfo:launchOptions];
    
    //初始化键盘
    [self initIQKeyboard];
    
    //初始化百度地图
    [self initBaiDuMap];
    
    /*
        1.导入微信支付SDK，注册微信支付
        2.设置微信的APPID为URL Schemes
        3.发起支付，吊起微信支付
        4.处理支付结果
     */
    [WXApi registerApp:WXAppId];
    
    
    //初始化环信SDK
    [self initHuanXin];

    
    
    return YES;
}

- (id)instantiateRootVC
{
    //当前本地存储的版本号
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_version"];
    SHLog(@"历史版本号：%@", currentVersion)
    //这是最新的版本号
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    SHLog(@"最新的版本号:%@", version)
    
    if ([currentVersion isEqualToString:version]) {
        _sh = [[SHTabBarController alloc] init];
        return _sh;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"app_version"];
        SHScrollerViewController *vc = [[SHScrollerViewController alloc] init];
        return vc;
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    SHLog(@"applicationWillResignActive")
}

//App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    SHLog(@"applicationDidEnterBackground")
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

//APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    SHLog(@"applicationWillEnterForeground")
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [self startLocation];
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    SHLog(@"applicationDidBecomeActive")
//    [self startLocation];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    SHLog(@"applicationWillTerminate")
}


#pragma mark - 判断用户首次下载应用
- (void)initUserDownload
{
    SHKeychainManager *manager = [SHKeychainManager default];
    NSString *data = [manager load:@"jiafutong"];
    if (data == nil) {
        SHLog(@"keychain首次下载应用并且保存")
        NSString *dataString = @"家服通";
        [manager save:data data:dataString];
    }
    SHLog(@"data = %@", data)
}


#pragma mark - HuanXin
- (void)initHuanXin
{
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"jftdevPush";
#else
    apnsCertName = @"jftdisPush";
//123       cn.iaapp.app.sixman
    //环信Demo中使用Bugly收集crash信息，没有使用cocoapods,库存放在ChatDemo-UI3.0/ChatDemo-UI3.0/3rdparty/Bugly.framework，可自行删除
    //如果你自己的项目也要使用bugly，请按照bugly官方教程自行配置
//    [Bugly startWithAppId:HuanXinAppKey];
#endif
    //Appkey:注册的Appkey，详细见下面注释
    //apnsCertName:推送证书名(不需要加后缀)
    EMOptions *options = [EMOptions optionsWithAppkey:HuanXinAppKey];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];

    
    if (SH_AppDelegate.personInfo.mobile) {
        [[EMClient sharedClient] loginWithUsername:SH_AppDelegate.personInfo.mobile password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                [[EMClient sharedClient] setApnsNickname:SH_AppDelegate.personInfo.mobile];
                //设置推送详情
                EMPushOptions *pushOptions = [[EMClient sharedClient] pushOptions];
                pushOptions.displayStyle = EMPushDisplayStyleMessageSummary;// 显示消息内容
                // options.displayStyle = EMPushDisplayStyleSimpleBanner // 显示“您有一条新消息”
                EMError *error = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
                if(!error) {
                    // 成功
                }else {
                    // 失败
                }
                
                
                if (_sh.msgVC) {
                    [_sh setupUnreadMessageCount];
                }
                
                //添加监听在线推送消息
                [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
                
                
            }
        }];
    }
    
    //代码注册离线推送
    UIApplication *application = [UIApplication sharedApplication];
    //ios10注册APNS
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
    }
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    SHLog(@"%@", noti)
    
    /**
     *  8001 111111
     *  555 555 13083099800 000000
     *  333 333 15705519179 000000
     *  444 444
     */
//    EMError *error = [[EMClient sharedClient] registerWithUsername:@"555" password:@"555"];
//    if (error==nil) {
//        SHLog(@"注册成功");
//    }
//
//    //自动登录
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
//        EMError *error = [[EMClient sharedClient] loginWithUsername:@"555" password:@"555"];
//    }
    
    
    [[DemoCallManager sharedManager] setMainController:_sh];
    
    
}

//监听环信在线推送消息
- (void)messagesDidReceive:(NSArray *)aMessages{
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收到环信通知" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                SHLog(@"收到的文字是 txt -- %@",txt);
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                SHLog(@"大图remote路径 -- %@"   ,body.remotePath);
                SHLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
                SHLog(@"大图的secret -- %@"    ,body.secretKey);
                SHLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
                SHLog(@"大图的下载状态 -- %u",body.downloadStatus);
                
                
                // 缩略图sdk会自动下载
                SHLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
                SHLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
                SHLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
                SHLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
                SHLog(@"小图的下载状态 -- %u",body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                SHLog(@"纬度-- %f",body.latitude);
                SHLog(@"经度-- %f",body.longitude);
                SHLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                SHLog(@"音频remote路径 -- %@"      ,body.remotePath);
                SHLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
                SHLog(@"音频的secret -- %@"        ,body.secretKey);
                SHLog(@"音频文件大小 -- %lld"       ,body.fileLength);
                SHLog(@"音频文件的下载状态 -- %u"   ,body.downloadStatus);
                SHLog(@"音频的时间长度 -- %u"      ,body.duration);
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                
                SHLog(@"视频remote路径 -- %@"      ,body.remotePath);
                SHLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                SHLog(@"视频的secret -- %@"        ,body.secretKey);
                SHLog(@"视频文件大小 -- %lld"       ,body.fileLength);
                SHLog(@"视频文件的下载状态 -- %u"   ,body.downloadStatus);
                SHLog(@"视频的时间长度 -- %u"      ,body.duration);
                SHLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
                
                // 缩略图sdk会自动下载
                SHLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
                SHLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
                SHLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
                SHLog(@"缩略图的下载状态 -- %u"      ,body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                SHLog(@"文件remote路径 -- %@"      ,body.remotePath);
                SHLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                SHLog(@"文件的secret -- %@"        ,body.secretKey);
                SHLog(@"文件文件大小 -- %lld"       ,body.fileLength);
                SHLog(@"文件文件的下载状态 -- %u"   ,body.downloadStatus);
            }
                break;
                
            default:
                break;
        }
    }
    
    if (_sh) {
        [_sh setupUnreadMessageCount];
    }
    
}



#pragma mark - baidumap
- (void)initBaiDuMap
{
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    //如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:BaiDuMAapKey  generalDelegate:nil];
    if (!ret) {
        SHLog(@"manager start failed!!!")
    } else {
        SHLog(@"manager start succeed!!!")
    }
    
    
}


#pragma mark - IQKeyboardManager
- (void)initIQKeyboard {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制电机背景是否手气键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour = IQAutoToolbarByTag;;//最新版的设置键盘的returnKey的关键字，可以点击键盘上的next建，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘
    
}


#pragma mark - JPush
- (void)initJPushServiceBaseInfo:(NSDictionary *)launchOptions
{
    //Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)     categories:nil];
    } else {
        [JPUSHService registerForRemoteNotificationTypes:(JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionAlert)
#else
                                           categories:nil];
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
#endif
                                           categories:nil];
    }
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            SHLog(@"推送消息==== %@",remoteNotification);
            [self jumpToViewController:remoteNotification];
        }
    }
    
   
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送161a3797c8541779ad6
            SHLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            _personInfo.registerID = registrationID;
            SHLog(@"%@", _personInfo.registerID)
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            SHLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
}


//注册了推送功能，iOS会自定回调以下方法，得到deviceToken，需要将deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    
    //Register - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //绑定环信的账号
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    SHLog(@"devicetoken ----- %@",deviceTokenString);

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    SHLog(@"JPush-error:%@", error)
}

/**
 *  JPUSHRegisterDelegate
 */
//iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    SHLog(@"willPresentNotification")
    //Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if (@available(iOS 10.0, *)) {
        if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
        
    }
    
    SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
    SHLog(@"%.2f", SH_AppDelegate.personInfo.volume)
    [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
    [player play:userInfo[@"aps"][@"alert"]];
    
    //SHLog(@"%@", userInfo)
    //active状态下收到的推送消息
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //前台运行收到推送消息
        //第一种情况前台运行
//        NSString *apnCount = userInfo[@"aps"][@"alert"];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送信息" message:apnCount delegate:self cancelButtonTitle:@"查看" otherButtonTitles:@"取消", nil];
//        alert.delegate = self;
//        [alert show];
        SHLog(@"UIApplicationStateActive：%@", userInfo)
        [self jumpToViewController:userInfo];
    } else {
        SHLog(@"UIApplicationStateActive：%@", userInfo)
    }
    if (_sh) {
        [_sh didReceiveLocalNotification:notification];
    }
}

/**
 *  iOS 10 Support
 *  接收到推送消息
 */
#pragma mark - 语音
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    SHLog(@"didReceiveNotificationResponse")
    
    //Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    SHLog(@"%@", userInfo)
    
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
    
    
    if ([userInfo[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
        [player setDefaultWithVolume:-1.0 rate:0.4 pitchMultipier:-1.0];
        [player play:userInfo[@"aps"][@"alert"]];
        //判断应用是在前台还是后台
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [self jumpToViewController:userInfo];
            SHLog(@"%@", userInfo)
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            //第二种情况后台挂起时，收到推送消息处理
            //第一种情况前台运行
            //        NSString *apnCount = userInfo[@"aps"][@"alert"];
            //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送信息" message:apnCount delegate:self cancelButtonTitle:@"查看" otherButtonTitles:@"取消", nil];
            //        alert.delegate = self;
            //        [alert show];
            //        [[NSNotificationCenter defaultCenter] postNotificationName:@"testNoti" object:nil userInfo:userInfo];
            SHLog(@"%@", userInfo)
            [self jumpToViewController:userInfo];
        } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            //APP没有运行，推送过来消息的处理
            SHLog(@"APP没有运行，推送过来消息的处理")
            
        }
        
    } else {
        if (_sh) {
            [_sh didReceiveLocalNotification:response.notification];
        }
    }
    
}
/**
 *  基于iOS 7 及以上的系统版本，如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    SHLog(@"didReceiveRemoteNotification")
    SHLog(@"userInfo---%@", userInfo)
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([userInfo[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
        [player setDefaultWithVolume:-1.0 rate:0.4 pitchMultipier:-1.0];
        [player play:userInfo[@"aps"][@"alert"]];
        
        if (application.applicationState == UIApplicationStateActive) {
            //这里写APP正在运行时，推送过来消息的处理
            SHLog(@"APP正在运行，推送过来消息的处理")
            
            [self jumpToViewController:userInfo];
            
        } else if (application.applicationState == UIApplicationStateInactive) {
            //APP在后台运行，推送过来消息的处理
            SHLog(@"APP在后台运行，推送过来消息的处理")
            [self jumpToViewController:userInfo];
            
        } else if (application.applicationState == UIApplicationStateBackground) {
            //APP没有运行，推送过来消息的处理
            SHLog(@"APP没有运行，推送过来消息的处理")
            
        }
    } else {
        [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
    }
    
}

/**
 *  基于iOS 6 及以下的系统版本，如果 App状态为正在前台或者点击通知栏的通知消
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    SHLog(@"%@", userInfo)
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    SHLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}

//推送跳转方法
- (void)jumpToViewController:(NSDictionary *)remoteNotification
{
    
    /**
     KEY:   SIGN_IN,//签到
            REGISTER,//注册
            SHARE,//分享
            NAME_Certification,//实名认证
            SKILL_Certification,//技能认证
            CREATE_SERVER,//创建服务
            CREATE_ORDER,//创建订单
            ADDRESS_BOOK,//通讯录
     **/
    UITabBarController *tab = _sh;
    UINavigationController *nvc = tab.selectedViewController;
    UIViewController *vc = nvc.visibleViewController;
    
    //SHLog(@"%@", remoteNotification)
    
    //将字段存入本地，在要跳转的页面用它来判断
//    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
//    [pushJudge setObject:@"push" forKey:@"push"];
//    [pushJudge synchronize];
    if (remoteNotification[@"model"]) {
        
        if ([remoteNotification[@"model"] isEqualToString:@"ORDER"] || [remoteNotification[@"model"] isEqualToString:@"SERVE"]) {
            //这里写要跳转的controller
            SHLog(@"订单通知")
            if ([vc isMemberOfClass:[SHMyOrderDetailVController class]]) {
                SHMyOrderDetailVController *avc = (SHMyOrderDetailVController *)vc;
                SHLog(@"显示当前页面")
                
            } else {
                SHMyOrderDetailVController *avc = (SHMyOrderDetailVController *)[self getDetailWithData:remoteNotification];
                avc.hidesBottomBarWhenPushed = YES;
                avc.inType = SHNotificationType;
                avc.orderNo = remoteNotification[@"value"];
                [vc.navigationController pushViewController:avc animated:YES];
            }
            
        } else if ([remoteNotification[@"model"] isEqualToString:@"GIFT"]) {
            SHLog(@"%@", remoteNotification[@"key"]);
            NSDictionary *dic = @{
                                  @"key":remoteNotification[@"key"]
                                  };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RedPackageNoti" object:nil userInfo:dic];
            if ([vc isMemberOfClass:[SHWelfareCenterVController class]]) {
                SHLog(@"显示红包页面")
            } else {
                SHWelfareCenterVController *avc = (SHWelfareCenterVController *)[self getWelfareVC:remoteNotification];
                [vc.navigationController pushViewController:avc animated:YES];
            }
        } else if ([remoteNotification[@"model"] isEqualToString:@"NEED"]) {
            if ([remoteNotification[@"key"] isEqualToString:@"NEED_REMIND"]) {      //需求报价
                SHLog(@"%@", remoteNotification[@"key"])
                SHNeedDetailVController *avc = (SHNeedDetailVController *)[self getNeedDetailVC:remoteNotification];
                avc.needId = [remoteNotification[@"value"] integerValue];
                [vc.navigationController pushViewController:avc animated:YES];
            } else if ([remoteNotification[@"key"] isEqualToString:@"ORDER_CREATE"]) {  //报价之后推送到详情
                SHMyOrderDetailVController *avc = (SHMyOrderDetailVController *)[self getDetailWithData:remoteNotification];
                avc.hidesBottomBarWhenPushed = YES;
                avc.inType = SHNotificationType;
                avc.orderNo = remoteNotification[@"value"];
                [vc.navigationController pushViewController:avc animated:YES];
            }
            
        } else if ([remoteNotification[@"model"] isEqualToString:@"BROADCAST"]) {
            SHMessageVController *avc = (SHMessageVController *)[self getMessageVC:remoteNotification];
            avc.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:avc animated:YES];
        }
        
    }
    
}

#pragma mark - 推送详情页
- (UIViewController *)getDetailWithData:(NSDictionary *)dic
{
    SHMyOrderDetailVController *vc = [[SHMyOrderDetailVController alloc] init];
    return vc;
}

- (UIViewController *)getWelfareVC:(NSDictionary *)dic
{
    SHWelfareCenterVController *vc = [[SHWelfareCenterVController alloc] init];
    return vc;
}

- (UIViewController *)getNeedDetailVC:(NSDictionary *)dic
{
    SHNeedDetailVController *vc = [[SHNeedDetailVController alloc] init];
    return vc;
}

- (UIViewController *)getMessageVC:(NSDictionary *)dic
{
    SHMessageVController *vc = [[SHMessageVController alloc] init];
    return vc;
}



-(UIViewController*)findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

-(UIViewController*) currentViewController {
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}





#pragma mark - UMeng
- (void)initUMengBaseInfo {
    //设置AppKey，是在友盟注册之后给到的key
    
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKEY];
    [UMConfigure initWithAppkey:UMKEY channel:@"App Store"]; // required
    
    
    //注册各个平台的AppKey和AppID
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppId appSecret:WXAppSecret redirectURL:shareUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppId appSecret:QQAppKey redirectURL:shareUrl];

    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
}

//支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        //其他如支付等SDK回调
        if ([url.host isEqualToString:@"safepay"]) {
            [self aliPayHandle:url];
            return YES;
        }
        else if ([url.description hasPrefix:[NSString stringWithFormat:@"%@://pay", WXAppId]])
        {
            [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        //支付宝微信回调
        if ([url.host isEqualToString:@"safepay"]) {
            [self aliPayHandle:url];
            return YES;
        }
        else if ([url.description hasPrefix:[NSString stringWithFormat:@"%@://pay", WXAppId]])
        {
            [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        //支付宝微信回调
        if ([url.host isEqualToString:@"safepay"]) {
            [self aliPayHandle:url];
            return YES;
        }
        else if ([url.description hasPrefix:[NSString stringWithFormat:@"%@://pay", WXAppId]])
        {
            [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

//支付宝成功回调
- (void)aliPayHandle:(NSURL *)url
{
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        SHLog(@"result = %@",resultDic);
        int resultStatus = [resultDic[@"resultStatus"] intValue];
        if (resultStatus == 9000) {
            //支付成功回调成功，这里需要向服务器端通知一下
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAliPayPaySuccess object:nil userInfo:@{@"pay":@"AKIPAY"}];
            SHLog(@"支付宝支付成功")
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAliPayPaySuccess object:nil userInfo:@{@"pay":@"AKIPAYFAIL"}];
            [MBProgressHUD showMBPAlertView:@"取消支付" withSecond:2.0];
        }
        
    }];
    
    // 授权跳转支付宝钱包，处理结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        SHLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        SHLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
}

//微信支付成功后的回调
- (void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp *)resp;
        switch(response.errCode)
        {
            case WXSuccess:
                //这里其实还需要向服务端查询一下返回的结果
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeiXinPayPaySuccess object:nil userInfo:@{@"pay":@"WEIXIN"}];
                SHLog(@"支付成功");
                break;
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeiXinPayPaySuccess object:nil userInfo:@{@"pay":@"WEIXINFAIL"}];
                [MBProgressHUD showMBPAlertView:@"取消支付！" withSecond:2.0];
                SHLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

#pragma mark - 定位
/**
 *  第一：导入苹果自带的库
 *  第二：我们要创建对象
 *  第三：我们要遵循协议
 *  第四：配置info.plist，添加两个字段
 */
- (void)startLocation
{
    _locationManager = [SHLocationManager shareInstance];
    _locationManager.locationManager.delegate = self;
    [_locationManager.locationManager requestWhenInUseAuthorization];
    [_locationManager.locationManager requestAlwaysAuthorization];
    _locationManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        //_locationManager.locationManager.allowsBackgroundLocationUpdates = YES;
        [_locationManager.locationManager requestLocation];
    }
    else {
        [_locationManager.locationManager startUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager.locationManager requestAlwaysAuthorization];
            }
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    _personInfo.longitude = oldCoordinate.longitude;
    _personInfo.latitude = oldCoordinate.latitude;
    //[manager stopUpdatingLocation];
    //SHLog(@"%f---%f", oldCoordinate.longitude, oldCoordinate.latitude)
    //SHLog(@"%f---%f", _personInfo.longitude, _personInfo.latitude)
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
//            SHLog(@"name:%@", place.name)                                   //位置名
//            SHLog(@"route:%@", place.thoroughfare)                          //街道
//            SHLog(@"subThoroughfare:%@", place.subThoroughfare)             //子街道
//            SHLog(@"city:%@", place.locality)                               //市
//            SHLog(@"subLocality:%@", place.subLocality)                     //区
//            SHLog(@"country:%@", place.country)                             //国家
            _personInfo.city = place.locality;
            _city = place.locality;
            //SH_AppDelegate.personInfo.city = _city;
            _personInfo.city = _city;
            //SHLog(@"%@", SH_AppDelegate.personInfo.city)
//            SHLog(@"%@", _personInfo.city)
            //SHLog(@"%@", SH_AppDelegate.personInfo.city)
            //SHLog(@"%@", _city)
            //SHLog(@"%@", place.locality)
        }
        
    }];
    //SHLog(@"%@", _city)
    
//    if ([self isPersonLogin]) {
//        if (_timer == nil) {
//            _timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
//        }
//    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    
}

/**
 *  开启上传经纬度计时器
 */
- (void)openLocationTimer
{
    SHLog(@"开启计时器")
    if ([self isPersonLogin]) {
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
            [_locationManager.locationManager startUpdatingLocation];
        }
    }
    
}

/**
 *  关闭上传经纬度计时器
 */
- (void)closeLocationTimer
{
    
    [_locationManager.locationManager stopUpdatingLocation];
    [_timer invalidate];
    _timer == nil;
}


/**
 *  定时上传经纬度
 */
- (void)updateLocation
{
    if (SH_AppDelegate.isPersonLogin) {
        NSDictionary *dic = @{
                              @"lng":@(_personInfo.longitude),
                              @"lat":@(_personInfo.latitude)
                              };
        //SHLog(@"%@", dic)
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHLocationUrl params:dic success:^(id JSON, int code, NSString *msg) {
            //SHLog(@"%d", code)
            if (code == 0) {
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}


//判断是否登录
- (BOOL)isPersonLogin
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:SH_TOKEN];
    //SHLog(@"token---------\n%@", token)
    if (token) {
        return YES;
    } else {
        return NO;
    }
}

//退出登录
- (void)userLogout
{
    [_personInfo resignLogin];
    [_tokenMap cleanToken];
    [_userData cleanUserData];
    [_locationManager stopLocation];
    [_timer invalidate];
    _timer = nil;
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        SHLog(@"退出成功");
        //不显示消息列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOutHuanXin" object:nil];
        
        if (_sh) {
            [_sh setupUnreadMessageCount];
        }
        
#warning 接入网易云的时候会用得到
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutHuanXin object:nil];
    }
    
}

//登录
- (void)userLogin
{
    SHLoginViewController *vc = [SHLoginViewController alloc];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:nav animated:YES completion:nil];
}

/**
 *  判断是否开启定位
 */
+ (BOOL)isLocationServiceOpen
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}


- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    SHLog(@"%@", error)
}

- (void)connectionStateDidChange:(EMConnectionState)aConnectionState
{
    SHLog(@"%d", aConnectionState)
}




@end


