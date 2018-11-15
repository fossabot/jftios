//
//  SHAddressCell.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/9.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHAddressModel;
@interface SHAddressCell : UITableViewCell


@property (nonatomic, strong) SHAddressModel *addressModel;

- (void)setAddressModel:(SHAddressModel *)addressModel;


@end
