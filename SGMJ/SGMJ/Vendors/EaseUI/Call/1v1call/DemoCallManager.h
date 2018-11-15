//
//  DemoCallManager.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 22/11/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Hyphenate/Hyphenate.h>
#import "EMCallOptions+NSCoding.h"

// 改成作为根控制器的类
@class SHTabBarController;
@interface DemoCallManager : NSObject

#if DEMO_CALL == 1

@property (nonatomic) BOOL isCalling;
// 改成作为根控制器的类
@property (strong, nonatomic) SHTabBarController *mainController;

+ (instancetype)sharedManager;

- (void)saveCallOptions;

- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType;

- (void)answerCall:(NSString *)aCallId;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

#endif

@end
