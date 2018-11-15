//
//  SH_StartViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/15.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_StartViewController.h"
#import "SHTabBarController.h"

//分页控件的高度
static const NSUInteger kPageControlHeight = 20;
@interface SH_StartViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *skipButton;

/*定时器*/
@property (nonatomic, weak) NSTimer *timer;
/*剩余时间*/
@property (nonatomic, assign) int adLeftTime;

@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;





@end

@implementation SH_StartViewController

//图片停留时间
static int const SHAdDuration = 3;


- (void)viewDidLoad {
    [super viewDidLoad];
        
    _imageView.image = [UIImage imageWithColor:[UIColor grayColor]];
    
    [self setTimerData];
    
}

- (void)setTimerData {
    
    self.adLeftTime = SHAdDuration;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)updateTime {
    //时间递减
    self.adLeftTime--;
    
    //更新文字
    NSString *title = [NSString stringWithFormat:@"跳过%zd秒", self.adLeftTime];
    [_skipButton setTitle:title forState:UIControlStateNormal];
    //广告倒计时
    if (self.adLeftTime == 0) {
        //跳过下一个页面
        SHLog(@"开始跳了")
        [self.timer invalidate];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[SHTabBarController alloc] init];
        SHLog(@"计时器消失")
    }
    
}

- (IBAction)skipButtonClick:(UIButton *)sender {
    
    //关闭定时器
    [self.timer invalidate];
    
    //跳转到tabbar
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SHTabBarController alloc] init];
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
