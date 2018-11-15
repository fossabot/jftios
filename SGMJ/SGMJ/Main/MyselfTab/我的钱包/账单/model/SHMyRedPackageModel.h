//
//  SHMyRedPackageModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/24.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMyRedPackageModel : NSObject




@property (nonatomic, copy) NSString *createTime;   //时间
@property (nonatomic, copy) NSString *Description;  //标题
@property (nonatomic, assign) double trxAmount;     //交易金额
@property (nonatomic, assign) double redCash;
@property (nonatomic, copy) NSString *trxType;      //join收入（+) expend消费(-)
@property (nonatomic, copy) NSString *bizType;      //类型




@end













