//
//  SHRelCataModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHRelCataModel : NSObject

@property (nonatomic, strong) NSArray *childList;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger type; //3.有终点位置




@end






