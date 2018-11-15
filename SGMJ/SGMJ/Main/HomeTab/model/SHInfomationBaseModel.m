//
//  SHInfomationBaseModel.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHInfomationBaseModel.h"
#import "NSCalendar+SHCommentDate.h"

@implementation SHInfomationBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"infomationId":@"id"
             };
}

- (void)setImageurl:(NSArray *)imageurl {
    
    if (imageurl.count == 0) {
        _imageurl = @[@"kongkongruye"];
    }else {
        
        _imageurl = imageurl;
    }
    self.cellType = imageurl.count == 1 ? InfomationCellTypeSingleImage : InfomationCellTypeThreeImages;
}

- (NSString *)createtime {
    return [NSCalendar commentDateByOriginalDate:_createtime withDateFormat:yyyyMMddHHmmss];
}

@end
