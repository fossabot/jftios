//
//  SG_HttpResponse.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/19.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SG_HttpResponse.h"

@implementation SG_HttpResponse
SingletonM(SG_HttpResponse)

- (id)returnHttpResponse:(id)json
{
    //SHLog(@"返回值：%@", json)
    NSDictionary *dict = json;
    self.baseCode = [dict[@"code"] intValue];
    self.baseMsg = dict[@"msg"];
    if (dict[@"data"]) {
        self.data = dict[@"data"];
    } else {
        self.data = nil;
    }
    return self;
}


@end
