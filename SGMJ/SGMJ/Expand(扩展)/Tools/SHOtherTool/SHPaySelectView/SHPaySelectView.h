//
//  SHPaySelectView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SHPayTypeSelect)(SH_PayUtilType payType);


@interface SHPaySelectView : UIView

@property (nonatomic, copy) SHPayTypeSelect payBlock;

- (void)showView;



@end
