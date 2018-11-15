//
//  InfomationThreeImagesCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "InfomationThreeImagesCell.h"

@implementation InfomationThreeImagesCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}


- (void)initUI {
    
    [self.contentView addSubview:self.image2];
    [self.contentView addSubview:self.image3];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(leftArightMargin);
        make.right.mas_equalTo(-leftArightMargin);
    }];
    
    NSArray *imgs = @[self.image,self.image2,self.image3];
    
    [imgs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:contentMargin leadSpacing:leftArightMargin tailSpacing:leftArightMargin];
    
    [imgs mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.title.mas_bottom).offset(contentMargin);
        make.height.mas_equalTo(imgWidth*imgHratio);
    }];
//    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(self.title.mas_bottom).offset(self.imageMargin);
//        make.left.mas_equalTo(self.imageMargin);
//        make.width.mas_equalTo(self.averageImageWidth);
//        make.height.mas_equalTo(self.averageImageWidth*self.imageScaleHratioW);
//    }];
//    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(self.image.mas_right).offset(self.imageMargin);
//        make.top.mas_equalTo(self.imageMargin);
//        make.width.mas_equalTo(self.averageImageWidth);
//        make.height.mas_equalTo(self.image);
//    }];
//    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(self.image2.mas_right).offset(self.imageMargin);
//        make.top.mas_equalTo(self.imageMargin);
//        make.width.mas_equalTo(self.averageImageWidth);
//        make.height.mas_equalTo(self.image);
//    }];

    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.image.mas_bottom).offset(contentMargin);
        make.left.mas_equalTo(self.image);
        make.bottom.mas_equalTo(-topAbottomMargin);
    }];
    
    
}


#pragma mark - lazy method

- (UIImageView *)image2 {
    if (!_image2) {
        _image2 = [[UIImageView alloc] init];
        
    }
    return _image2;
}

- (UIImageView *)image3 {
    if (!_image3) {
        _image3 = [[UIImageView alloc] init];
        
    }
    return _image3;
}



@end
