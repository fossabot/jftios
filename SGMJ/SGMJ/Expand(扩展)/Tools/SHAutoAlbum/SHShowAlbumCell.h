//
//  SHShowAlbumCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHShowAlbumCell : UICollectionViewCell
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//按钮选定
@property (nonatomic, copy) void (^selectedBlock) (NSInteger index);
//取消选定
@property (nonatomic, copy) void (^cancelBlock)(NSInteger index);


//按钮事件
- (IBAction)clickBtn:(UIButton *)sender;


@end
