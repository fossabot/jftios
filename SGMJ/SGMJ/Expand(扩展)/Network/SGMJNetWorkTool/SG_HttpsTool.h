//
//  SG_HttpsTool.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SG_Singleton.h"
#import "ViewController.h"
@class SHLoginViewController;

/**
 *  基础参数Base节点key
 */
#define Key_Req_Base            @"base"
#define Key_Req_Param           @"param"
#define Key_Resp_Base           @"base"
#define Key_Resp_Data           @"data"
#define Key_Resp_Data_Other     @"other"
#define Key_Resp_Code           @"code"
#define Key_Resp_Msg            @"msg"

/**
 *  配合后台的请求数据
 */
typedef void (^HttpSuccessBlock)(id JSON, int code, NSString *msg);
typedef void(^HttpFailureBlock)(NSError *error);

typedef NS_ENUM(NSUInteger, SHServiceAndRequied) {
    SHServiceType     = 0,                      //服务
    SHRequiredType                              //需求
};

typedef NS_ENUM(NSUInteger, SHRegisterAndFindPsd) {
    SHRegisterStatus = 0,                       //注册
    SHFindPsdStatus,                            //找回密码
};

typedef NS_ENUM(NSUInteger, SHMessageAndBind) {
    SHMessageLoginType  =   0,                  //短信登录
    SHBindPhoneType                             //绑定手机号
};

typedef NS_ENUM(NSUInteger, SHAddressType) {
    SHAddressNewAddType             =   0,      //新增收货地址
    SHAddressEditType                           //编辑收货地址
    
};


typedef NS_ENUM(NSUInteger, SHModifyInfoTyoe) {
    SHModifySignatureType           =   0,      //修改个性签名
    SHModifyNicknameType,                       //修改昵称
    SHQuesAndSuggestType                        //问题和建议
};

typedef NS_ENUM(NSUInteger, SHRefreshUpAndDownType) {//1.上拉， 2下拉
    SHInTheFirstTimeType              =   0,      //刚刚进去
    SHDownLoadingType                 =   1,      //下啦
    SHUpLoadingType                   =   2,      //上拉
};


typedef NS_ENUM(NSUInteger, SHOrderAndSkillApplyType) {
    SHOrderDoneType                 =   0,      //订单完成认证
    SHSkillAuthoriseType,                       //技能认证
    SHFeedBackType,                             //投诉
    SHSuggestBackType                           //建议反馈
};


typedef NS_ENUM(NSUInteger, SHPushOrderDetailType) {
    SHNotificationType              =   0,      //推送出来的页面
    SHOrderListPushType                         //订单详情的页面
};

typedef NS_ENUM(NSUInteger, SHAllOrderStatusType) {
    SHAllOrderType                  =   0,      //全部
    SHWaitPaidType                  =   1,      //待付款
    SHWaitSendGoodType              =   2,      //待发货
    SHWaitReceiveGppdType           =   3,      //待收货
    SHWaitEvaluteType               =   4       //待评价
};

typedef NS_ENUM(NSUInteger, SHOrderChangeStatusType) {  //消费者             服务者
    INIT                            =   0,      //取消订单+立即付款
    RECEIVE                         =   1,      //我要催单                  立即出发
    UN_CONFIRMED                    =   2,      //确认服务
    UN_EVALUATION                   =   3,      //待评价
    SUCCESS                         =   4,      //已完结
};

typedef NS_ENUM(NSUInteger, SHNeedTingAndOrderType) {
    SHNeedTingType,                             //需求
    SHOrderType,                                //订单
    SHMyReleaseType,                            //我的发布
    SHMyWalletListType,                         //我的钱包明细
    SHMyEvaluateType                            //我的评价
};

typedef NS_ENUM(NSUInteger, SHRedPackageAllType) {
    SHSignRedPackageType,                       //签到红包
    SHRegisterRedPackageType,                   //注册红包
    SHAuthoriseRedPackageType,                  //实名红包
    SHSkillRedPackageType,                      //发布技能红包
    SHShoppRedPackageType,                      //交易红包
    SHShareRedPackageType,                      //分享红包
    
};

typedef NS_ENUM(NSUInteger, SHWithdrawlType) {
    SHMyWalletLeftMoneyType,                    //我的零钱
    SHRedPackageLeftMoneyType                   //红包余额
};

typedef NS_ENUM(NSUInteger, SHFollowAndFansType) {
    SHFollowOtherType,                          //关注类型
    SHFansPeopleType,                            //粉丝类型
    SHGoodFriendTypy                            //好友
};

typedef NS_ENUM(NSUInteger, SHEvaluateIntoType) {
    SHEvaluateOrderNoType,                      //订单评价
    SHModifyEvaluateAsseIdType                  //修改评价
};


@interface SG_HttpsTool : NSObject
SingletonH(SG_HttpsTool)

@property(nonatomic, weak) ViewController *viewContrller;

- (void)showAlert:(NSString *)title message:(NSString *)message;
/**
 *  get请求
 *  @param url URL
 *  @param params 请求体
 *  @param success 成功Block
 *  @param failure 失败Block
 */
- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure;

/**
 *  post请求
 *  @param url URL
 *  @param params 请求体
 *  @param success 成功Block
 *  @param failure 失败Block
 */
- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;


/**
 *  下载网络图片
 *  @param url url
 *  @param place 占位图
 *  @param imageView 显示控件
 */
- (void)downloadImage:(NSString *)url
                place:(NSString *)place
            imageView:(UIImageView *)imageView;


/**
 *  上传图片
 */
+ (void)uploadImageWithURL:(NSString *)url
                     image:(UIImage *)image
                   success:(HttpSuccessBlock)success
                   failure:(HttpFailureBlock)failure;




/**
 *  上传图片 （单张）
 *  @param path         路径
 *  @param image        图片
 *  @param params       参数
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)uploadImageWithPath:(NSString *)path image:(UIImage *)image params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;


/**
 *  上传图片（多张）
 *  @param path         路径
 *  @param photos       图片数组
 *  @param params       参数
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)uploadImageWithPath:(NSString *)path photos:(NSArray *)photos params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;




@end

