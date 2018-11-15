//
//  SH_PictureScanView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

//需要的webImage头文件
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>

/**
 *  视图展示结构，基于collectionview
 */
@class SH_PictureScanView;
typedef void(^SHPicScanBlock)(NSString *event);


@interface SH_PictureScanView : UIView

@property (nonatomic, copy) SHPicScanBlock eventBlock;

- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgsArray withImgUrl:(NSArray *)imgUrlArray;

@end


/**
 *  PictureCell
 */
@class PictureCell;
typedef void(^HiddenBlock)(NSString *gest);

@interface PictureCell: UICollectionViewCell

@property (nonatomic, copy) HiddenBlock myBlock;

- (void)createUIWithImage:(UIImage *)image ImgUrl:(NSString *)imageUrl withIndex:(NSInteger)index;

@end


















