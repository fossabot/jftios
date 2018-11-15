//
//  SHBirthdayPickerView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/5/15.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SHPickerTypeBirthdayType,               //生日选择器
} SHPickerViewType;

typedef void(^BirthdaySelectedSureBtnClick)(NSString *result);


//@protocol SHPickerViewDelegate
//
//- (void)didClickSureButton:(NSString *)selectedString;
//- (void)didClickCancelButton;
//
//@end

@interface SHBirthdayPickerView : UIView

/**
 *  设置中心标题文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) BirthdaySelectedSureBtnClick selectBlock;

//@property (nonatomic, weak) id <SHPickerViewDelegate> delegate;

@property (nonatomic, assign) SHPickerViewType pickerViewType;


- (void)showPickerView;
- (void)hidePickerView;


@end
