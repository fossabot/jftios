//
//  SHInfomationBaseModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

typedef NS_ENUM(NSUInteger, InfomationCellType) {
    InfomationCellTypeSingleImage = 0,
    InfomationCellTypeThreeImages = 1,
    InfomationCellTypeBigImage = 2
};

#import <Foundation/Foundation.h>

@interface SHInfomationBaseModel : NSObject


@property (nonatomic, assign) InfomationCellType cellType;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *imageurl;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *infomationId;
@property (nonatomic, copy) NSString *type;



@end
