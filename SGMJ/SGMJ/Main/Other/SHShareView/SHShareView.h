//
//  SHShareView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHShareModel.h"


typedef NS_ENUM(NSUInteger, SHShareType) {
    SHShareTypeWeChatSession    =   1,      //微信好友
    SHShareTypeWeChatTimeline   =   2,      //微信朋友圈
    SHShareTypeQQ               =   3,      //QQ好友
    SHShareTypeQzone            =   4,      //QQ空间
    SHShareTypeErWeiMa          =   5,      //二维码
    
};

typedef NS_ENUM(NSUInteger, SHShareContentType) {
    SHShareContentTypeText      =   1,      //文本分享
    SHShareContentTypeImage     =   2,      //图片分享
    SHShareContentTypeLink      =   3,      //链接分享
    SHShareContentTypeErWeiMa   =   4,      //二维码
    //...其他自行扩展
};


@interface SHShareView : UIView


/**
 *  分享试图弹框
 *  @param shareModel 分享的数据
 *  @param shareContentType 分享类型
 */
- (void)showShareViewWithSHShareModel:(SHShareModel *)shareModel shareContentType:(SHShareContentType)shareContentType;



@end





