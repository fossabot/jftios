//
//  SHSkillModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/31.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSkillModel : NSObject

@property (nonatomic, strong) NSArray *childList;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger isNav;
@property (nonatomic, assign) NSInteger isSelected;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) NSInteger sortOrder;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;






@end
