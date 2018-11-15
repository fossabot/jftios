//
//  API.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/30.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#ifndef API_h
#define API_h





//token
#define SH_TOKEN                        @"token"
//域名http://app.jiafutong.net/      测试服务器http://116.62.216.8/
#define ipUrlString                     @"http://116.62.216.8/"
#define baseUrlString                   @"https://app.jiafutong.net/"
//上传图片地址
#define imageUrlString                  @"http://www.shuhuikeji.com:8091/files/upload/image"
//图片拼接地址
#define imageSuccessUrl                 @"http://www.shuhuikeji.com"

//分享链接地址
#define SHShareLinkUrl                  @"http://m.jiafutong.net/red_packet_index/"

//实时定位
#define SHLocationUrl                   @"app/share/geographic"             //实时定位接口

#define SH_TokenUrl                     @"auth"                             //获取token接口
#define SH_SecretAuthUrl                @"sms/auth"                         //获取uuid
#define SHMessageUrl                    @"sms/send"                         //短信验证码接口
#define SHRegisterUrl                   @"register"                         //注册接口
#define SHForgetPsdUrl                  @"forgetPassword"                   //忘记密码接口
#define SHLoginUrl                      @"login"                            //登录接口
#define SHLogoutUrl                     @"app/user/loginOut"                //退出登录
#define SHThirdLoginUrl                 @"thirdLogin"                       //三方登录
#define SHBindPhoneUrl                  @"bindMobile"                       //绑定手机号
#define SHRegisterIDUrl                 @"app/bind/jpush"                   //极光ID

#define SHInfoUrl                       @"app/user/info"                    //个人信息
#define SHImageLoadUrl                  @"files/upload/image"               //图片上传
#define SHUpdateInfo                    @"app/user/updateUserInfo"          //信息修改
#define SHAddAddressUrl                 @"app/user/address/create"          //添加地址
#define SHAddressListUrl                @"app/user/address/list"            //地址列表
#define SHEditorAddressUrl              @"app/user/address/edit"            //编辑地址
#define SHDefaultAddUrl                 @"app/user/address/setDefault"      //设为默认
#define SHDeleteAddUrl                  @"app/user/address/del"             //删除地址

#define SHHomeDataUrl                   @"app/index"                        //首页
#define SHReleaServCatUrl               @"app/category/list"                //发布服务分类选择
#define SHReleaseServiceUrl             @"app/serve/create"                 //发布服务
#define SHVerifyCardInfoUrl             @"app/user/idCard/auth"             //身份实名认证
#define SHCheckAuthoriseUrl             @"app//user/check/verify"           //用户是否实名认证
#define SHHomeServiceListUrl            @"app/serve/list"                   //服务列表页
#define SHOrderFillInUrl                @"app/order/create"                 //订单填写
#define SHYueCheckUrl                   @"app/order/prepaid"                //支付页面余额查询
#define SHAlipayRequestUrl              @"app/pay/gotoZFB"                  //支付宝支付请求
#define SHAlipaySuccessBackUrl          @"app/pay/zfb/back"                 //支付宝支付成功回调
#define SHWeiXinRequestUrl              @"app/pay/gotoWEIXIN"               //微信支付请求
#define SHWeiXinSuccessBackUrl          @"app/pay//weixin/back"             //微信支付回调
#define SHYuePayRequestUrl              @"app/gotoBalance/create"           //余额支付凭条
#define SHYuePayPasswordUrl             @"app/user/set/payPass"             //设置支付密码
#define SHYuePayUrl                     @"app/gotoBalance/pay"              //余额支付接口

#define SHReleaseAdverUrl               @"app/ad/create"                    //发布广告

#define SHAdverDetailUrl                @"app/advertisement/info"           //广告详情
#define SHAnswerCommitUrl               @"app/advertisement/answer"         //答题

#define SHModifyLoginPsdUrl             @"app/user/changeLoginPass"         //修改登录密码
#define SHModifyPayPsdUrl               @"app/user/change/payPass"          //修改支付密码
#define SHOrderListUrl                  @"app/order/list"                   //订单列表
#define SHMySkillUrl                    @"app/user/profession/list"         //我的技能列表
#define SHAllSkillListUrl               @"app/user/category/list"           //所有技能列表
#define shCreateSkillUrl                @"app/user/profession/create"       //创建技能
#define SHSkillAuthoriseUrl             @"app/user/profession/auth"         //申请认证接口
#define SHSystemMessageUrl              @"app/index/getMsgList"             //系统消息
#define SHOrderDetailUrl                @"app/order/info"                   //订单详情

#define SHGoToSerRightNowUrl            @"app/order/confirmDeparture"       //立即出发
#define SHSureServiceUrl                @"app/order/confirmServe"           //确认服务
#define SHOrderDoneUploadUrl            @"app/order/sellerUpload"           //订单完成上传凭证
#define SHEvaluteOrderUrl               @"app/order/assess"                 //立即评价订单
#define SHCuiDanOrderUrl                @"app/order/remind"                 //我要催单
#define SHCancelOrderUrl                @"app/order/cancel"                 //取消订单

#define SHSignInGetMoneyUrl             @"app/redCash/open"                 //签到领红包
#define SHSignInListUrl                 @"app/redCash/signInList"           //签到页数据

#define SHMyWalletUrl                   @"app/user/balance"                 //我的钱包

#define SHMyCenterUrl                   @"app/ucenter"                      //我的页面

#define SHNeedTingUrl                   @"app/need/list"                    //需求大厅
#define SHReleaseNeedUrl                @"app/need/create"                  //发布需求
#define SHOpenReceiveOrderUrl           @"app/need/openServe"               //是否开启接单
#define SHNeedDetailUrl                 @"app/need/details"                 //需求订单详情
#define SHWelfareCenterUrl              @"app/gift/check"                   //福利中心
#define SHReportPriceUrl                @"app/need/offer"                   //立即报价
#define SHNeedCreateOrderUrl            @"app/need/createOrder"             //需求下单
#define SHPersonalInfoUrl               @"app/getUserInformation"           //个人主页
#define SHMoneyListDataUrl              @"app/account/details"              //零钱明细
#define SHShareBeforeUrl                @"app/share"                        //分享前
#define SHMyPublishUrl                  @"app/user/publish"                 //我的发布
#define SHFollowOtherUrl                @"app/user/care"                    //关注他人
#define SHDayGetRedPackageUrl           @"app/share/query"                  //天天领红包
#define SHWithdrwalMoneyUrl             @"app/user/carryCash"               //用户提现接口
#define SHCheckIsMyFriendUrl            @"app/check/isMyFriend"             //检测是否是好友
#define SHMyFriendListUrl               @"app/query/im/friendList"          //好友列表

#define SHFeedBackAndSugUrl             @"app/suggestion"                   //建议反馈投诉
#define SHTeamInfluenceUrl              @"app/user/teamWork"                //团队影响力
#define SHServiceDetailUrl              @"app/serve/details"                //服务详情

#define SHGetServicerLocUrl             @"app/serve/location"               //获取服务者经纬度
#define SHFollowAndFansUrl              @"app/user/fansAndFollow"           //关注和粉丝

#define SHMyEvaluateListUrl             @"app/assess/list/query"            //我的评价
#define SHEvaluateDetailUrl             @"app/assess/details"               //评价详情
#define SHReplayEvaluateUrl             @"app/assess/reply"                 //回复评价
#define SHModifyEvaDetUrl               @"app/assess/info"                  //修改前的评价内容
#define SHModifyEvaluteUrl              @"app/assess/update"                //修改评价
#define SHUpdateEvaluteUrl              @"app/assess/update"                //更新评价

#define SHHomeSearchUrl                 @"app/index/search"                 //搜索



#endif /* API_h */
