//
//  SH_SHSoundPlayer.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_SHSoundPlayer : NSObject

@property (nonatomic, assign) float rate;           //语速
@property (nonatomic, assign) float volume;         //音量
@property (nonatomic, assign) float pitchMultiplier;//音调
@property (nonatomic, assign) BOOL autoPlay;        //自动播放

@property (nonatomic, assign) BOOL isOpen;          //是否开启语音

//类方法
+ (SH_SHSoundPlayer *)SHSoundPlayerInit;

//基础设置，如果有别的设置，也很好的实现
- (void)setDefaultWithVolume:(float)aVolume rate:(CGFloat)aRate pitchMultipier:(CGFloat)aPitchMultiplier;

//播放并给出文字
- (void)play:(NSString *)string;





@end
