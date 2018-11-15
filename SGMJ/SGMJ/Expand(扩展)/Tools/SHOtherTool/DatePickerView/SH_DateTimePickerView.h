//
//  SH_DateTimePickerView.h
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/21.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SHDatePickerViewYMDHM,          //年月日时分
    SHDatePickerViewYMD,            //年月日
    SHDatePickerViewHM,             //时分
    SHDatePickerViewDefaultYMD      //默认生日
} SHDatePicerViewMode;

@protocol SHDateTimePickerViewDelegate <NSObject>
@optional
/**
 *  确定按钮
 */
- (void)didClickFinishDateTimePickerView:(NSString *)date;

/**
 *  取消按钮
 */
- (void)didClickCancelDateTimePickerView;

@end

@interface SH_DateTimePickerView : UIView

/**
 *  设置中心标题文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) id<SHDateTimePickerViewDelegate> dateDelegate;

/**
 *  显示时间模式
 */
@property (nonatomic, assign) SHDatePicerViewMode pickerViewMode;

/**
 *  隐藏pickerView
 */
- (void)hideDateTimePickerView;

/**
 *  显示pickerView
 */
- (void)showDateTimePickerView;

@end









