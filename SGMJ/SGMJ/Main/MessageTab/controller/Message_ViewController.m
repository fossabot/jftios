//
//  Message_ViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "Message_ViewController.h"
#import "SHFriendListTableViewController.h"

@interface Message_ViewController ()

@end

@implementation Message_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)friendListButtonClick:(UIButton *)sender {
    
    SHFriendListTableViewController *vc = [[SHFriendListTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
