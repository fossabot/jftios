//
//  SHHelpViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/8/23.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHHelpViewController.h"

@interface SHHelpViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SHHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"帮助";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scrollView.contentSize = CGSizeMake(SHScreenW, _scrollView.height + 300);
    });
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
