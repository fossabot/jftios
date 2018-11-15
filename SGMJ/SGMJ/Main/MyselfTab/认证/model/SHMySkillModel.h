//
//  SHMySkillModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMySkillModel : NSObject


@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, assign) NSInteger isAvailable;
@property (nonatomic, copy) NSString *reply;
@property (nonatomic, assign) NSInteger status;             //0   1.审核中  2成功  3失败
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *verifyTime;




@end
