//
//  SHOrderStatuesCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHOrderStatuesCell.h"
#import "SHMyOrderCenterVController.h"
#import "SHOrderListViewController.h"

#import "SHMyCenterModel.h"

@interface SHOrderStatuesCell ()




@end

@implementation SHOrderStatuesCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _noPayLabel.layer.cornerRadius = _noPayLabel.height / 2;
    _noSendGoodLabel.layer.cornerRadius = _noSendGoodLabel.height / 2;
    _noReceiveGoodLabel.layer.cornerRadius = _noReceiveGoodLabel.height / 2;
    _noCommitLabel.layer.cornerRadius = _noCommitLabel.height / 2;
    _noPayLabel.clipsToBounds = YES;
    _noSendGoodLabel.clipsToBounds = YES;
    _noReceiveGoodLabel.clipsToBounds = YES;
    _noCommitLabel.clipsToBounds = YES;
    
    
    
    
}

- (void)setMyModel:(SHMyCenterModel *)myModel
{
    _myModel = myModel;
    
    if (SH_AppDelegate.personInfo.waitPayNum == 0) {
        _noPayLabel.hidden = YES;
    } else {
        _noPayLabel.hidden = NO;
        _noPayLabel.text = [NSString stringWithFormat:@"%d", SH_AppDelegate.personInfo.waitPayNum];
    }
    if (SH_AppDelegate.personInfo.waitSerNum == 0) {
        _noSendGoodLabel.hidden = YES;
    } else {
        _noSendGoodLabel.hidden = NO;
        _noSendGoodLabel.text = [NSString stringWithFormat:@"%d", SH_AppDelegate.personInfo.waitSerNum];
    }
    if (SH_AppDelegate.personInfo.waitSureNum == 0) {
        _noReceiveGoodLabel.hidden = YES;
    } else {
        _noReceiveGoodLabel.hidden = NO;
        _noReceiveGoodLabel.text = [NSString stringWithFormat:@"%d", SH_AppDelegate.personInfo.waitSureNum];
    }
    if (SH_AppDelegate.personInfo.waitEvaNum == 0) {
        _noCommitLabel.hidden = YES;
    } else {
        _noCommitLabel.hidden = NO;
        _noCommitLabel.text = [NSString stringWithFormat:@"%d", SH_AppDelegate.personInfo.waitEvaNum];
    }
}

- (IBAction)orderStatusButtonClick:(UIButton *)sender {
    SHLog(@"%ld", (long)sender.tag)
    SHOrderListViewController *vc = [[SHOrderListViewController alloc] init];
    if (sender.tag == 10) {             //待付款
        vc.index = 1;
    } else if (sender.tag == 11) {      //待发货
        vc.index = 2;
    } else if (sender.tag == 12) {      //待收货
        vc.index = 3;
    } else if (sender.tag == 13) {      //待评价
        vc.index = 4;
    }
    [[self viewController].navigationController pushViewController:vc animated:YES];
}


- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    UIViewController *vc = nil;
    return vc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
