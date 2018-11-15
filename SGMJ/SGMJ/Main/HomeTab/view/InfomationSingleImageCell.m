//
//  InfomationSingleImageCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/10/25.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "InfomationSingleImageCell.h"



@implementation InfomationSingleImageCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}


#pragma mark - lazy method

- (void)initUI {
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.mas_equalTo(leftArightMargin);
        make.height.mas_equalTo(imgWidth*imgHratio);
        make.width.mas_equalTo(imgWidth);
        make.bottom.mas_equalTo(-topAbottomMargin);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.image.mas_right).offset(leftArightMargin);
        make.top.mas_equalTo(self.image);
        make.right.mas_equalTo(-leftArightMargin);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.title);
        make.bottom.mas_equalTo(self.image);
    }];
    
    
    
}



@end
