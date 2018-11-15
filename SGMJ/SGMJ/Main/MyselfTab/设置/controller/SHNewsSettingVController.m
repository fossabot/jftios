//
//  SHNewsSettingVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/29.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHNewsSettingVController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface SHNewsSettingVController ()

@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;





@end

@implementation SHNewsSettingVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"新消息提醒";
    if (SH_AppDelegate.personInfo.volume == 0.0) {
        [_voiceSwitch setOn:NO];
    } else {
        [_voiceSwitch setOn:YES];
    }
    
    [_shakeSwitch setOn:NO];
    
}

- (IBAction)voiceSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        SH_AppDelegate.personInfo.volume = 1.0;
    } else {
        SH_AppDelegate.personInfo.volume = 0.0;
    }
    SHLog(@"%f", SH_AppDelegate.personInfo.volume)
}

- (IBAction)shakeSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    } else {
        
    }
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
