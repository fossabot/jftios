//
//  SHMyReleaseCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMyReleaseCell : UITableViewCell



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLeftContraint;

@property (weak, nonatomic) IBOutlet UIImageView *picImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;


@property (weak, nonatomic) IBOutlet UILabel *secTitleL;
@property (weak, nonatomic) IBOutlet UIImageView *shelvesImgV;


@end
