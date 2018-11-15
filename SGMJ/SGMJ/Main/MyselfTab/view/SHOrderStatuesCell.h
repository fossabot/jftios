//
//  SHOrderStatuesCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHMyCenterModel;

@interface SHOrderStatuesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noPayLabel;           //待付款
@property (weak, nonatomic) IBOutlet UILabel *noSendGoodLabel;      //待发货
@property (weak, nonatomic) IBOutlet UILabel *noReceiveGoodLabel;   //待收货
@property (weak, nonatomic) IBOutlet UILabel *noCommitLabel;        //待评价


@property (nonatomic, strong) SHMyCenterModel *myModel;


@end
