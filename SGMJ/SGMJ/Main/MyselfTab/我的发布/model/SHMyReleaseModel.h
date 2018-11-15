//
//  SHMyReleaseModel.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/15.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMyReleaseModel : NSObject



@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, assign) NSInteger ID;




@end
