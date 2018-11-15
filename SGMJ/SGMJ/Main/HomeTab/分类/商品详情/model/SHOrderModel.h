//
//  SHOrderModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHOrderModel : NSObject


@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger buyNum;
@property (nonatomic, assign) NSInteger buyerId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contentImgUrl;
@property (nonatomic, copy) NSString *couponCodeId;
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger ID;


@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *orderState;
@property (nonatomic, assign) NSInteger payStatus;
@property (nonatomic, copy) NSString *sumPrice;//总价格



/**
 address = "\U8bf7\U9009\U62e9\U670d\U52a1\U65f6\U95f4\U6052\U5174\U5e7f\U573a";
 buyNum = 1;
 buyerId = 1;
 content = "\U6d4b\U8bd5";
 contentImgUrl = "";
 couponCodeId = "";
 createTime = "2018-07-04 17:08:04";
 dataType = serve;
 endTime = "2018-07-04 17:08:04";
 externalOrderNo = "";
 freight = 0;
 freightPrice = 0;
 goodsId = 6;
 id = 5;
 lat = "31.85370635986328";
 lng = "117.3133544921875";
 loseTime = "2018-07-04 17:08:04";
 modelId = 7;
 name = "\U5468";
 orderNo = NO153069528409816;
 orderState = INIT;
 orderType = "PUBLIC_TYPE";
 payStatus = 0;
 payTime = "2018-07-04 17:08:04";
 payType = "";
 phone = 13083099800;
 realPrice = 1;
 sellerId = "";
 startTime = "2018-07-04 17:08:04";
 sumPrice = 1;
 toPay = 0;
 unit = "\U4e2a";
 verificationCode = "";
 yhPrice = 0;
 **/








@end
