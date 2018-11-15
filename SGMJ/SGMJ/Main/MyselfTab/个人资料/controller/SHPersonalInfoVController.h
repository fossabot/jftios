//
//  SHPersonalInfoVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHModifyBlock)(NSString *string);


@interface SHPersonalInfoVController : ViewController


@property (nonatomic, copy) SHModifyBlock modifyBlock;


@end
