//
//  SHModifyInfoVController.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "ViewController.h"


typedef void(^SHModifyInfoBlock)(NSString *infomation);

@interface SHModifyInfoVController : ViewController


@property (nonatomic, copy) NSString *titleString;



@property (nonatomic, assign) SHModifyInfoTyoe modifyType;


@property (nonatomic, copy) SHModifyInfoBlock infoBlock;


@end
