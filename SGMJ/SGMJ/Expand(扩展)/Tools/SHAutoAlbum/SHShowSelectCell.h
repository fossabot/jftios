//
//  SHShowSelectCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHShowSelectCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
@property (nonatomic, copy) void(^deletBlock) (NSInteger index);


- (IBAction)clickDeleteBtn:(UIButton *)sender;



@end
