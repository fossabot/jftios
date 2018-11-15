//
//  SG_HttpResponse.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SG_Singleton.h"
@interface SG_HttpResponse : NSObject
SingletonH(SG_HttpResponse)

/**
 *  返回的状态码
 *  code = 700，token错误
 *  code = 500，服务器范发生错误
 *  code = 100，继续操作
 */
@property (nonatomic, assign) int       baseCode;

/**
 *  返回的提示信息
 */
@property (nonatomic, copy) NSString    *baseMsg;

/**
 *  返回的数据
 */
@property (nonatomic, strong) id        data;

- (id)returnHttpResponse:(id)json;

//- (id)newsReturnHttpResponse:(id)json;


@end
