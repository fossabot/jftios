//
//  SH_PayUtil.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_PayUtil.h"
#import "Order.h"
#import "APRSASigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SH_PayAlipayModel.h"
#import <WXApi.h>
#import "SH_PayWXModel.h"

@implementation SH_PayUtil

+ (SH_PayUtil *)sharedInstance
{
    static SH_PayUtil *shPayUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shPayUtil = [[SH_PayUtil alloc] init];
    });
    return shPayUtil;
}

- (void)gotoPay:(SH_PayUtilType)payUtilType withPayMoney:(double)money withOrder:(SHOrderModel *)orderModel
{
    double payMoney = 0;
    //处理微信的金额
    if (payUtilType == kSH_PayUtilTypeWXPay) {
        payMoney = money * 100;
    } else {
        payMoney = money;
    }
    switch (payUtilType) {
        case kSH_PayUtilTypeAlipay:
            [self AlipayWithMoney:payMoney withOrder:orderModel];
            break;
        case kSH_PayUtilTypeWXPay:
            [self WXPayWithMoney:payMoney withOrder:orderModel];
            break;
        case kSH_PayUtilTypeYue:
            
            break;
            
        default:
            break;
    }
    
}

//支付宝
- (void)AlipayWithMoney:(double)money withOrder:(SHOrderModel *)orderModel
{
    //SHWeakSelf
    NSDictionary *dic = @{
                          @"orderNo":orderModel.orderNo
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHAlipayRequestUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            SH_PayAlipayModel *aliModel = [SH_PayAlipayModel mj_objectWithKeyValues:JSON[@"alipaymentOrder"]];
            
            NSString *rsa2PrivateKey = AliPrivateKey;
            NSString *rsaPrivateKey = @"";
            //AppIDhe PrivateKey没有配置的提示
            if ([AlipayAppId length] == 0 || [AliPrivateKey length] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少appid或者私钥" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            
            /**
             *  生成订单信息
             *  将商品信息赋予AliPayOrder的成员变量
             */
            Order *order = [[Order alloc] init];
            //appid
            order.app_id = AlipayAppId;
            //支付接口名称
            order.method = @"alipay.trade.app.pay";
            //参数编码格式
            order.charset = @"utf-8";
            //当前时间点
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            order.timestamp = [formatter stringFromDate:[NSDate date]];
            
            //支付版本
            order.version = @"1.0";
            order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
            order.notify_url = aliModel.notifyUrl;
            
            order.biz_content = [BizContent new];
            order.biz_content.body = aliModel.Description;
            //支付宝支付页面的订单信息
            order.biz_content.subject = aliModel.title;
            //订单id
            order.biz_content.out_trade_no = aliModel.outTradeNo;
            //超时时间
            order.biz_content.timeout_express = @"30s";
            //价格
            order.biz_content.total_amount = aliModel.totalAmount;
            
            order.biz_content.product_code = @"QUICK_MSECURITY_PAY";
            
            /**
             *  将商品信息拼接成字符串
             */
            NSString *orderInfo = [order orderInfoEncoded:NO];
            NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
            //SHLog(@"orderSpec = %@", orderInfo)
            
            //获取私钥并将商户信息签名，外部商户的加签过程务必放在服务端，防止公钥数据泄露
            //需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
            NSString *signedString = nil;
            APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
            if ((rsa2PrivateKey.length > 1)) {
                signedString = [signer signString:orderInfo withRSA2:YES];
            } else {
                signedString = [signer signString:orderInfo withRSA2:NO];
            }
            SHLog(@"%@", signedString)
            //如果加签成功，则继续执行支付
            if (signedString != nil) {
                //应用注册scheme，在info.plist定义URL types
                //将签名成功字符串格式化为订单字符串，请严格按照该格式
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@", orderInfoEncoded, signedString];
                //调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:AliAppScheme callback:^(NSDictionary *resultDic) {
                    int resultStatus = [resultDic[@"resultStatus"] intValue];
                    SHLog(@"%d", resultStatus)
                    if (resultStatus == 9000) {
                        
                    }
                }];
                
            }

        }
    } failure:^(NSError *error) {
        
    }];
    
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    
    
}

//微信
- (void)WXPayWithMoney:(double)money withOrder:(SHOrderModel *)orderModel
{
    //根据查询微信API文档，我们需要添加两个需要的判断
    //判断是否安装了微信
    // 1.当前设备是否安装了微信
    // 2.当前设备安装的微信是否支持微信支付
//    if (![WXApi isWXAppInstalled]) {
//        SHLog(@"没有安装微信")
//        [MBProgressHUD showMBPAlertView:@"您还没有安装微信" withSecond:2.0];
//        return;
//    } else if (![WXApi isWXAppSupportApi]) {
//        SHLog(@"不支持微信支付")
//        [MBProgressHUD showMBPAlertView:@"您的微信还没有开通支付功能" withSecond:2.0];
//        return;
//    }
    SHLog(@"安装了微信有支付功能！！！")
    NSDictionary *dic = @{
                          @"orderNo":orderModel.orderNo
                          };
    SHLog(@"%@", dic)
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHWeiXinRequestUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            SH_PayWXModel *model = [SH_PayWXModel mj_objectWithKeyValues:JSON[@"map"]];
            PayReq *req = [[PayReq alloc] init];
            //由用户微信号和AppID组成的唯一标识，用于校验微信用户
            req.openID = model.appid;
            // 商家id，在注册的时候给的
            req.partnerId = model.partnerid;
            // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
            req.prepayId = model.prepayid;
            // 根据财付通文档填写的数据和签名
            req.package = model.package;
            // 随机编码，为了防止重复的，在后台生成
            req.nonceStr = model.noncestr;
            //时间戳
            req.timeStamp = model.timestamp.intValue;
            //签名
            req.sign = model.sign;
            //[WXApi sendReq:req];
            if ([WXApi sendReq:req]) {
                SHLog(@"调起微信成功。。。")
            } else {
                SHLog(@"调起微信失败。。。")
            }
            
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}


- (void)alipayWithOrderString:(NSString *)orderString withOrderNo:(NSString *)orderNo
{
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AliAppScheme callback:^(NSDictionary *resultDic) {
        int resultStatus = [resultDic[@"resultStatus"] intValue];
        SHLog(@"%d", resultStatus)
        if (resultStatus == 9000) {
            SHLog(@"支付成功")
            
        } else {
            SHLog(@"取消支付")
        }
    }];
}



#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}








@end
