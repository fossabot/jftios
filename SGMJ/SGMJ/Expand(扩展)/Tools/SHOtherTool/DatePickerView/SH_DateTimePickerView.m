//
//  SH_DateTimePickerView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/21.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_DateTimePickerView.h"

@interface SH_DateTimePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger monthRange;
    NSInteger hourRange;
    NSInteger minuteRange;
    
    NSInteger startYear;
    NSInteger startMonth;
    NSInteger startDay;
    NSInteger startHour;
    NSInteger startMinute;
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    
    NSCalendar *calendar;
    
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
}

@property (nonatomic, strong) UIPickerView *pickerView;     //pickerView
@property (nonatomic, strong) NSString *string;             //选中时间字符串
@property (nonatomic, strong) UIView *contentV;             //pickerView所在的view
@property (nonatomic, strong) UIView *bgView;               //大的背景view


@property (nonatomic, assign) NSInteger comYearN;           //年 行数差
@property (nonatomic, assign) NSInteger comMonthN;          //月 行数差
@property (nonatomic, assign) NSInteger comDayN;            //日 行数差
@property (nonatomic, assign) NSInteger comHourN;           //时 行数差
@property (nonatomic, assign) NSInteger comMinN;            //分 行数差


@end


@implementation SH_DateTimePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SH_RGBA(0, 0, 0, 0.5);
        self.alpha = 0;
        
        //pickerView所在背景view
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, SHScreenH - 64, SHScreenW, 220)];
        contentV.backgroundColor = SH_WhiteColor;
        [self addSubview:contentV];
        self.contentV = contentV;
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SHScreenW, 180)];
        self.pickerView.backgroundColor = SH_WhiteColor;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [contentV addSubview:self.pickerView];
        
        //盛放按钮的view
        UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 40)];
        upView.backgroundColor = SH_WhiteColor;
        [contentV addSubview:upView];
        
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 40, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.backgroundColor = SH_ClearColor;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitleColor:SH_UIColorFromRGB(0x008dd6) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upView addSubview:cancelButton];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake(SHScreenW - 52, 0, 40, 40);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        chooseButton.backgroundColor = SH_ClearColor;
        chooseButton.titleLabel.font = SH_FontSize(15);
        [chooseButton setTitleColor:SH_UIColorFromRGB(0x008dd6) forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upView addSubview:chooseButton];
        
        //中间显示文字
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), 0, SHScreenW - 104, 40)];
        _titleLabel.text = @"";
        [upView addSubview:_titleLabel];
        _titleLabel.textColor = SH_UIColorFromRGB(0x3f4548);
        _titleLabel.font = SH_FontSize(13);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //分割线
        UIView *spliteView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SHScreenW, 0.6)];
        spliteView.backgroundColor = SH_UIColorFromRGB(0xe6e6e6);
        [upView addSubview:spliteView];
        
        //获取当前的时间
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        
        startYear = year;
        startMonth = month;
        startDay = day;
        startHour = 0;
        startMinute = 0;
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",startYear,startMonth,startDay,startHour,startMinute];
        
        yearRange = 5;
        dayRange = 30;
        
        _comYearN = 0;
        _comMonthN = 0;
        _comDayN = 0;
        _comHourN = 0;
        _comMinN = 0;
        
        //[self setCurrentDate:[NSDate date]];
        
    }
    return self;
}

//返回天数
- (NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day = 0;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day = 30;
            break;
        case 2:
        {
            if (((year%4==0)&&(year%100!=0))||(year%400==0)) {
                day = 29;
                break;
            }
            else
            {
                day = 28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

//默认时间的处理
- (void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前的时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar components:unitFlags fromDate:currentDate];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    
    startYear = year;
    startMonth = month;
    
    //当前年-月-日-时-分-秒
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    selectedHour = hour;
    selectedMinute = minute;
    
    //本月的天数
    dayRange = [self isAllDay:year andMonth:month];
    
    //pickerView选中哪一行
    if (self.pickerViewMode == SHDatePickerViewYMDHM) {
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-startMonth inComponent:1 animated:NO];
        [self.pickerView selectRow:day-startDay inComponent:2 animated:NO];
        [self.pickerView selectRow:hour-startHour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute-startMinute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-startMonth inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-startDay inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour-startHour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute-startMinute inComponent:4];
        
        
    }else if (self.pickerViewMode == SHDatePickerViewYMD){
        [self.pickerView selectRow:_comYearN inComponent:0 animated:NO];
        [self.pickerView selectRow:_comMonthN inComponent:1 animated:NO];
        [self.pickerView selectRow:_comDayN inComponent:2 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:_comYearN inComponent:0];
        [self pickerView:self.pickerView didSelectRow:_comMonthN inComponent:1];
        [self pickerView:self.pickerView didSelectRow:_comDayN inComponent:2];
    }else if (self.pickerViewMode == SHDatePickerViewHM){
        [self.pickerView selectRow:_comHourN inComponent:0 animated:NO];
        [self.pickerView selectRow:_comMinN inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:_comHourN inComponent:0];
        [self pickerView:self.pickerView didSelectRow:_comMinN inComponent:1];
    }
    [self.pickerView reloadAllComponents];
}


#pragma mark - UIPickerViewDataSource
//pickView返回多少列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == SHDatePickerViewYMDHM) {
        return 5;
    } else if (self.pickerViewMode == SHDatePickerViewYMD) {
        return 3;
    } else if (self.pickerViewMode == SHDatePickerViewHM) {
        return 2;
    }
    return 0;
}

//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewMode == SHDatePickerViewYMDHM) {
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                if (selectedYear == startYear) {
                    return 12 - startMonth + 1;
                } else {
                    return 12;
                }
            }
                break;
            case 2:
            {
                if (selectedYear == startYear && selectedMonth == startMonth) {
                    return dayRange - startDay + 1;
                } else {
                    return dayRange;
                }
            }
                break;
            case 3:
            {
                if (selectedYear == startYear && selectedMonth == startMonth && selectedDay == startDay) {
                    return 24 - startHour;
                } else {
                    return 24;
                }
            }
                break;
            case 4:
            {
                if (selectedYear == startYear && selectedMonth == startMonth && selectedDay == startDay && selectedHour == startHour) {
                    return 60 - startMinute;
                } else {
                    return 60;
                }
            }
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode == SHDatePickerViewYMD) {
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                if (selectedYear == startYear) {
                    return 12 - startMonth + 1;
                } else {
                    return 12;
                }
            }
                break;
            case 2:
            {
                if (selectedYear == startYear && selectedMonth == startMonth) {
                    return dayRange - startDay + 1;
                } else {
                    return dayRange;
                }
            }
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode == SHDatePickerViewHM) {
        switch (component) {
                
            case 0:
            {
                //return 24 - startHour + 1;
                return 24;
            }
                break;
            case 1:
            {
                if (selectedHour == startHour) {
                    //return 60 - startMinute;
                    return 60;
                } else {
                    return 60;
                }
            }
                break;
                
            default:
                break;
        }
    }
    return 0;
}

#pragma amrk - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SHScreenW * component / 6.0, 0, SHScreenW / 6.0, 30)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.tag = component * 100 + row;
    label.textAlignment = NSTextAlignmentCenter;
    if (self.pickerViewMode == SHDatePickerViewYMDHM) {
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年", (long)(startYear + row)];
            }
                break;
            case 1:
            {
                if (selectedYear == startYear) {
                    label.text = [NSString stringWithFormat:@"%ld月", (long)(startMonth + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%ld月", (long)(1 + row)];
                }
            }
                break;
            case 2:
            {
                if (selectedYear == startYear && selectedMonth == startMonth) {
                    label.text = [NSString stringWithFormat:@"%ld日", (long)(startDay + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%ld日", (long)(1 + row)];
                }
            }
                break;
            case 3:
            {
                if (selectedYear == startYear && selectedMonth == startMonth && selectedDay == startDay) {
                    label.text = [NSString stringWithFormat:@"%ld时", (long)(startHour + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%ld时", (long)row];
                }
            }
                break;
            case 4:
            {
                if (selectedYear == startYear && selectedMonth == startMonth && selectedDay == startDay && selectedHour == startHour) {
                    label.text = [NSString stringWithFormat:@"%ld分", (long)(startMinute + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%ld分", (long)row];
                }
            }
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode == SHDatePickerViewYMD) {
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年", (long)(startYear + row)];
            }
                break;
            case 1:
            {
                if (selectedYear == startYear) {
                    label.text = [NSString stringWithFormat:@"%ld月", (long)(startMonth + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%ld月", (long)row + 1];
                }
            }
                break;
            case 2:
            {
                if (selectedYear == startYear && selectedMonth == startMonth) {
                    label.text = [NSString stringWithFormat:@"%ld日", (long)(startDay + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%ld日", (long)row + 1];
                }
            }
                break;
                
            default:
                break;
        }
    } else if (self.pickerViewMode == SHDatePickerViewHM) {
        switch (component) {
            case 0:
            {
                //[NSString stringWithFormat:@"%ld时",(long)row + startHour]
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
                
            }
                break;
            case 1:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
                
            }
                break;
                
            default:
                break;
        }
    }
    return label;
}

//每一列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.pickerViewMode == SHDatePickerViewYMDHM) {
        return (SHScreenW - 40) / 5;
    } else if (self.pickerViewMode == SHDatePickerViewYMD) {
        return (SHScreenW - 40) / 3;
    } else if (self.pickerViewMode == SHDatePickerViewHM) {
        return (SHScreenW - 40) / 2;
    }
    return 0;
}

//行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

//改变年份
- (void)yearChanged {
    //    SHLog(@"%ld", _comMonthN)
    //    SHLog(@"%ld", _comDayN)
    //    SHLog(@"%ld", _comHourN)
    //    SHLog(@"%ld", _comMinN)
    if (selectedYear == startYear) {
        selectedMonth = startMonth + _comMonthN;
        
        if (startMonth + _comMonthN >= 12) {
            selectedMonth = 12;
            _comMonthN = 12 - startMonth;
        } else {
            //年数相同，月数相同，比较天数
            if (selectedMonth == startMonth) {
                selectedDay = startDay + _comDayN;
                if (startDay + _comDayN >= dayRange) {
                    selectedDay = dayRange;
                    _comDayN = dayRange - startDay;
                } else {
                    selectedDay = _comDayN + startDay;
                    if (selectedDay == startDay) {
                        selectedHour = startHour + _comHourN;
                        if (startHour + _comHourN >= 23) {
                            selectedHour = 24;
                            _comHourN = 23 - startHour;
                        } else {
                            selectedHour = startHour + _comHourN;
                            if (selectedHour == startHour) {
                                if (startMinute + _comMinN >= 59) {
                                    selectedMinute = 59;
                                    _comMinN = 59 - startMinute;
                                } else {
                                    selectedMinute = startMinute + _comMinN;
                                }
                            } else {
                                selectedMinute = _comMinN;
                            }
                        }
                    } else {
                        selectedHour = _comHourN + 1;
                    }
                }
            } else {
                selectedDay = _comDayN + 1;
            }
        }
        
    } else {
        selectedMonth = _comMonthN + 1;
        selectedDay = _comDayN + 1;
        selectedHour = _comHourN;
        selectedMinute = _comMinN;
    }
}

//改变月份
- (void)changeMonth {
    //    SHLog(@"%ld", _comMonthN)
    //    SHLog(@"%ld", _comDayN)
    //    SHLog(@"%ld", _comHourN)
    //    SHLog(@"%ld", _comMinN)
    if (selectedYear == startYear) {
        selectedMonth = startMonth + _comMonthN;
        dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
        if (selectedMonth == startMonth) {
            //滑动的天数row
            if (startDay + _comDayN >= dayRange) {
                selectedDay = dayRange;
                _comDayN = dayRange - startDay;
            } else {
                selectedDay = _comDayN + startDay;
                if (selectedDay == startDay) {
                    selectedHour = startHour + _comHourN;
                    if (startHour + _comHourN >= 23) {
                        selectedHour = 23;
                        _comHourN = 23 - startHour;
                    } else {
                        selectedHour = startHour + _comHourN;
                        if (selectedHour == startHour) {
                            if (startMinute + _comMinN >= 59) {
                                selectedMinute = 59;
                                _comMinN = 59 - startMinute;
                            } else {
                                selectedMinute = startMinute + _comMinN;
                            }
                        } else {
                            selectedMinute = _comMinN;
                        }
                    }
                } else {
                    selectedHour = _comHourN;
                }
            }
        } else {
            selectedDay = _comDayN + 1;
            selectedHour = _comHourN;
            selectedMinute = _comMinN;
        }
    } else {
        selectedMonth = 1 + _comMonthN;
        dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
        selectedDay = _comDayN + 1;
        if (_comDayN + 1 >= dayRange) {
            selectedDay = dayRange;
            _comDayN = dayRange - 1;
        }
        selectedMinute = _comMinN;
    }
    
}

//改变天数
- (void)dayChange {
    //    SHLog(@"%ld", _comMonthN)
    //    SHLog(@"%ld", _comDayN)
    //    SHLog(@"%ld", _comHourN)
    //    SHLog(@"%ld", _comMinN)
    if (selectedYear == startYear && selectedMonth == startMonth) {
        if (startDay + _comDayN >= dayRange) {
            selectedDay = dayRange;
            _comDayN = dayRange - selectedDay;
        } else {
            selectedDay = startDay + _comDayN;
        }
        if (selectedDay == startDay) {
            selectedHour = startHour + _comHourN;
            if (startHour + _comHourN >= 23) {
                selectedHour = 23;
                _comHourN = 23 - startHour;
            } else {
                selectedHour = startHour + _comHourN;
                if (selectedHour == startHour) {
                    if (startMinute + _comMinN >= 59) {
                        selectedMinute = 59;
                        _comMinN = 59 - startMinute;
                    } else {
                        selectedMinute = startMinute + _comMinN;
                    }
                } else {
                    selectedMinute = _comMinN;
                }
            }
        } else {
            selectedHour = _comHourN;
            selectedMinute = _comMinN;
        }
        
    } else {
        selectedDay = _comDayN + 1;
        selectedHour = _comHourN;
        selectedMinute = _comMinN;
    }
}

//改变hour
- (void)hourChange {
    //    SHLog(@"%ld", _comMonthN)
    //    SHLog(@"%ld", _comDayN)
    //    SHLog(@"%ld", _comHourN)
    //    SHLog(@"%ld", _comMinN)
    if (selectedYear == startYear && selectedMonth == startMonth && selectedDay == startDay) {
        if (selectedHour == startHour) {
            if (startMinute + _comMinN >= 59) {
                selectedMinute = 59;
                _comMinN = 59 - startMinute;
            } else {
                selectedMinute = startMinute + _comMinN;
            }
        } else {
            selectedMinute = _comMinN;
        }
    } else {
        selectedMinute = _comMinN;
        selectedHour = _comHourN;
    }
    
}

//改变minute
- (void)minuteChange {
    //    SHLog(@"%ld", _comMonthN)
    //    SHLog(@"%ld", _comDayN)
    //    SHLog(@"%ld", _comHourN)
    //    SHLog(@"%ld", _comMinN)
    if (selectedYear == startYear && selectedMonth == startMonth && selectedDay == startDay && selectedHour == startHour) {
        if (startMinute + _comMinN >= 59) {
            selectedMinute = 59;
            _comMinN = 59 - startMinute;
        } else {
            selectedMinute = startMinute + _comMinN;
        }
    } else {
        selectedMinute = _comMinN;
    }
}

//监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewMode == SHDatePickerViewYMDHM) {
        switch (component) {
            case 0:
            {
                //改变年----刷新天数
                selectedYear = startYear + row;
                [self yearChanged];
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
                [self.pickerView reloadComponent:3];
                [self.pickerView reloadComponent:4];
            }
                break;
            case 1:
            {
                _comMonthN = row;
                //改变月----刷新天数
                [self changeMonth];
                [self.pickerView reloadComponent:2];
                [self.pickerView reloadComponent:3];
                [self.pickerView reloadComponent:4];
            }
                break;
            case 2:
            {
                _comDayN = row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                selectedDay = row + startDay;
                [self dayChange];
                [self.pickerView reloadComponent:3];
                [self.pickerView reloadComponent:4];
            }
                break;
            case 3:
            {
                _comHourN = row;
                selectedHour = row + startHour;
                [self hourChange];
                [self.pickerView reloadComponent:4];
            }
                break;
            case 4:
            {
                _comMinN = row;
                selectedMinute = row + startMinute;
                [self minuteChange];
            }
                break;
                
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
    } else if (self.pickerViewMode == SHDatePickerViewYMD) {
        switch (component) {
            case 0:
            {
                
                selectedYear = startYear + row;
                if (selectedYear == startYear) {
                    if (startMonth + _comMonthN >= 12) {
                        selectedMonth = 12;
                        _comMonthN = 12 - startMonth;
                    } else {
                        selectedMonth = startMonth + _comMonthN;
                    }
                    if (selectedMonth != startMonth) {
                        selectedDay = _comDayN + 1;
                    } else {
                        if (_comDayN + startDay >= dayRange) {
                            selectedDay = dayRange;
                            _comDayN = _comDayN + startDay - dayRange + 1;
                        } else {
                            selectedDay = _comDayN + 1;
                        }
                    }
                } else {
                    selectedMonth = _comMonthN + 1;
                    selectedDay = _comDayN + 1;
                }
                
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                _comMonthN = row;
                //改变月----刷新天数
                [self changeMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                _comDayN = row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                selectedDay = row + startDay;
                [self dayChange];
            }
                break;
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
    } else if (self.pickerViewMode == SHDatePickerViewHM) {
        switch (component) {
            case 0:
            {
                selectedHour = row;
                _comHourN = row;
            }
                break;
            case 1:
            {
                _comMinN = row;
                selectedMinute = row;

            }
                break;
                
            default:
                break;
        }
        SHLog(@"%ld", selectedHour)
        SHLog(@"%ld", selectedMinute)
        _string =[NSString stringWithFormat:@"%ld:%ld",selectedHour,selectedMinute];
    }
}


#pragma mark - 隐藏、显示view
- (void)hideDateTimePickerView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        _contentV.frame = CGRectMake(0, SHScreenH, SHScreenW, 220);
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, SHScreenH - 64, SHScreenW, SHScreenH - 64);
    }];
}

- (void)showDateTimePickerView
{
    //显示pickerView的时候，显示当前时间
    //[self setCurrentDate:[NSDate date]];
    self.frame = CGRectMake(0, 0, SHScreenW, SHScreenH);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        _contentV.frame = CGRectMake(0, SHScreenH - 220 - 64, SHScreenW, 220);
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - private 取消、确定事件
- (void)cancelButtonClick
{
    if (self.dateDelegate != nil && [self.dateDelegate respondsToSelector:@selector(didClickCancelDateTimePickerView)]) {
        [self.dateDelegate didClickCancelDateTimePickerView];
    }
    [self hideDateTimePickerView];
}

- (void)configButtonClick
{
    
    if (self.pickerViewMode == SHDatePickerViewYMDHM) {
        SHLog(@"年月日：%ld--%ld--%ld--%ld--%ld", (long)selectedYear,(long)selectedMonth, (long)selectedDay, (long)selectedHour, (long)selectedMinute)
    } else if (self.pickerViewMode == SHDatePickerViewYMD) {
        SHLog(@"年月日：%ld--%ld--%ld", (long)selectedYear,(long)selectedMonth, (long)selectedDay)
    } else if (self.pickerViewMode == SHDatePickerViewHM) {
        SHLog(@"年月日：%ld--%ld", (long)selectedHour, (long)selectedMinute)
        if (selectedHour < 10 && selectedMinute < 10) {
            _string = [NSString stringWithFormat:@"0%ld:0%ld", selectedHour, selectedMinute];
        } else if (selectedHour < 10 && selectedMinute >= 10) {
            _string = [NSString stringWithFormat:@"0%ld:%ld", selectedHour, selectedMinute];
        } else if (selectedHour >= 10 && selectedMinute < 10) {
            _string = [NSString stringWithFormat:@"%ld:0%ld", selectedHour, selectedMinute];
        } else if (selectedHour > 10 && selectedMinute >= 10) {
            _string = [NSString stringWithFormat:@"%ld:%ld", selectedHour, selectedMinute];
        }
    }
    
    _string = [NSString stringWithFormat:@"%@", _string];
    SHLog(@"%@", _string)
    if (self.dateDelegate != nil && [self.dateDelegate respondsToSelector:@selector(didClickFinishDateTimePickerView:)]) {
        [self.dateDelegate didClickFinishDateTimePickerView:_string];
    }
    [self hideDateTimePickerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideDateTimePickerView];
}


@end

