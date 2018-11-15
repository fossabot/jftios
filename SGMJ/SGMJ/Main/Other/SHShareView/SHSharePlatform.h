//
//  SHSharePlatform.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/26.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareView.h"

@interface SHSharePlatform : NSObject

@property (nonatomic, copy) NSString *iconStateNormal;
@property (nonatomic, copy) NSString *iconStateHighlighted;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) SHShareType sharePlatform;


@end
