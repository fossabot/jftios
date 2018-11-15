//
//  SH_SHSoundPlayer.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_SHSoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
static SH_SHSoundPlayer *soundplayer = nil;

@implementation SH_SHSoundPlayer

+ (SH_SHSoundPlayer *)SHSoundPlayerInit
{
    if (soundplayer == nil) {
        soundplayer = [[SH_SHSoundPlayer alloc] init];
        [soundplayer setDefaultWithVolume:-1.0 rate:-1.0 pitchMultipier:-1.0];
    }
    return soundplayer;
}

//播放声音
- (void)play:(NSString *)string
{
    if (string && string.length) {
        AVSpeechSynthesizer *player = [[AVSpeechSynthesizer alloc] init];
        //设置语音内容
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
        //设置语言
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        //设置语速
        utterance.rate = self.rate;
        
//        //play shake
//        if ([UserDefaultsGet(ALLOW_USER_KEY_PLAY_SHAKE) integerValue] == 1) {
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        }
//        //play audio
//        if ([UserDefaultsGet(ALLOW_USER_KEY_PLAY_AUDIO) integerValue] == 1) {
//            static SystemSoundID soundIDTest = 0;
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"bbs" ofType:@"caf"];
//            if (path) {
//                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest);
//            }
//            AudioServicesPlaySystemSound(soundIDTest);
//        }
        
        SHLog(@"没有语音")
        
        utterance.volume = self.volume;
        //设置语调（0.5-2.0）
        utterance.pitchMultiplier = self.pitchMultiplier;
        //目的是让语音合成器播放下一语句前有短暂的暂停
        utterance.postUtteranceDelay = 1;
        [player speakUtterance:utterance];
    }
}

/**
 *  初始化设置
 *  设置播放的声音参数   如果选择器默认请传入-1.0
 *  @param aVolume               音量（0.0-1.0）默认为1.0
 *  @param aRate                 语速（0.0-1.0）
 *  @param aPitchMultiplier      语调（0.5-2.0）
 */
- (void)setDefaultWithVolume:(float)aVolume rate:(CGFloat)aRate pitchMultipier:(CGFloat)aPitchMultiplier
{
    self.rate = aRate;
    self.volume = aVolume;
    self.pitchMultiplier = aPitchMultiplier;
    
    if (aRate == -1.0) {
        self.rate = 1;
    }
    
    if (aVolume == -1.0) {
        self.volume = 1;
    }
    
    if (aPitchMultiplier == -1.0) {
        self.pitchMultiplier = 1;
    }
    
}





















@end
