//
//  SHMenu.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMenu : NSObject

+ (SHMenu *)shareManager;


- (void) showPopMenuSelecteWithFrameWidth:(CGFloat)width
                                   height:(CGFloat)height
                                    point:(CGPoint)point
                                     item:(NSArray *)item
                                imgSource:(NSArray *)imgSource
                                   action:(void (^)(NSInteger index))action;





@end
