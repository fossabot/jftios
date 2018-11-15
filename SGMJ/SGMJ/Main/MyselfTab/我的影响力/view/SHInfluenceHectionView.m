//
//  SHInfluenceHectionView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHInfluenceHectionView.h"

@interface SHInfluenceHectionView()


@end

@implementation SHInfluenceHectionView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"SHInfluenceHectionView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
    
}

@end
