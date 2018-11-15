//
//  SHUpdateViewAlert.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/2.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHUpdateViewAlert.h"
#import "SHUpdateAlertConst.h"

#define DEFAULT_MAX_HEIGHT SCREEN_HEIGHT/3*2

@interface SHUpdateViewAlert()

/**
 *  版本号
 */
@property (nonatomic, copy) NSString *version;

/**
 *  版本更新内容
 */
@property (nonatomic, copy) NSString *desc;

@end

@implementation SHUpdateViewAlert

- (instancetype)initVersion:(NSString *)version description:(NSString *)description
{
    self = [super init];
    if (self) {
        self.version = version;
        self.desc = description;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - privateFunction
- (void)setupUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = SH_RGBA(0, 0, 0, 0.3);
    
    //获取更新内容高度
    CGFloat descHeight = [self sizeOfString:self.desc font:[UIFont systemFontOfSize:SHDescriptionFont] maxSize:CGSizeMake(self.frame.size.width - Ratio(80) - Ratio(56), 1000)].height;
    
    //bgView的实际高度
    CGFloat realHeight = descHeight + Ratio(314);
    
    //bgView最大高度
    CGFloat maxHeight = DEFAULT_MAX_HEIGHT;
    
    //更新内容是否滑动显示
    BOOL scrollEnabled = NO;
    
    //重置bgView最大高度，设置更新内容可否滑动显示
    if (realHeight > DEFAULT_MAX_HEIGHT) {
        scrollEnabled = YES;
        descHeight = DEFAULT_MAX_HEIGHT - Ratio(314);
    } else {
        maxHeight = realHeight;
    }
    
    //backgroundView
    UIView *bgView = [[UIView alloc] init];
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(40), maxHeight + Ratio(18));
    [self addSubview:bgView];
    
    //添加更新提示
    UIView *updateView = [[UIView alloc] initWithFrame:CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width - Ratio(40), maxHeight)];
    updateView.backgroundColor =SH_WhiteColor;
    updateView.layer.cornerRadius = 4.0f;
    updateView.layer.masksToBounds = YES;
    [bgView addSubview:updateView];
    
    //下方的关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.centerX = self.frame.size.width / 2 - 15;
    closeButton.centerY = CGRectGetMaxY(bgView.frame) + 20;
    closeButton.size = CGSizeMake(30, 30);
    [closeButton setImage:[[UIImage imageNamed:@"VersionUpdate_Cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    
    //图片距顶20 + 图片高度166 + 主title跟图片距离10 + 主title高度28 + 10 + 文本descHeight + 20 + 立即更新按钮高度40 + 20 = 314 + descHeight 内部元素高度计算bgView高度
    //图片
    UIImageView *updateImageV = [[UIImageView alloc] initWithFrame:CGRectMake((updateView.frame.size.width - Ratio(178)) / 2, Ratio(20), Ratio(178), Ratio(166))];
    updateImageV.image = [UIImage imageNamed:@"VersionUpdate_Icon"];
    [updateView addSubview:updateImageV];
    
    //发现新版本
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Ratio(10) + CGRectGetMaxY(updateImageV.frame), updateView.frame.size.width, Ratio(28))];
    versionLabel.font = [UIFont boldSystemFontOfSize:18];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = [NSString stringWithFormat:@"发现新版本 V%@", self.version];
    [updateView addSubview:versionLabel];
    
    //更新内容
    UITextView *descTextV = [[UITextView alloc] initWithFrame:CGRectMake(Ratio(28), Ratio(10) + CGRectGetMaxY(versionLabel.frame), updateView.frame.size.width - Ratio(56), descHeight)];
    descTextV.font = [UIFont systemFontOfSize:SHDescriptionFont];
    descTextV.textContainer.lineFragmentPadding = 0;
    descTextV.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    descTextV.text = self.desc;
    descTextV.editable = NO;
    descTextV.selectable = NO;
    descTextV.scrollEnabled = scrollEnabled;
    descTextV.showsVerticalScrollIndicator = scrollEnabled;
    descTextV.showsHorizontalScrollIndicator = NO;
    [updateView addSubview:descTextV];
    
    if (scrollEnabled) {
        //如显示滑动条，提示可以有滑动条
        [descTextV flashScrollIndicators];
    }
    
    //更新按钮
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    updateButton.backgroundColor = SH_RGBA(34, 153, 238, 1);
    updateButton.frame = CGRectMake(Ratio(25), CGRectGetMaxY(descTextV.frame) + Ratio(20), updateView.frame.size.width - Ratio(50), Ratio(40));
    updateButton.layer.cornerRadius = 2.0f;
    updateButton.clipsToBounds = YES;
    [updateButton addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [updateButton setTitleColor:SH_WhiteColor forState:UIControlStateNormal];
    [updateView addSubview:updateButton];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.center = CGPointMake(CGRectGetMaxX(updateView.frame), CGRectGetMinY(updateView.frame));
    cancelButton.bounds = CGRectMake(0, 0, Ratio(36), Ratio(36));
    [cancelButton setImage:[[UIImage imageNamed:@"VersionUpdate_Cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelButton];
    
    //显示更新
    [self showWithAlert:bgView];
    
}

/**
 *  更新按钮点击事件
 */
- (void)updateVersion
{
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/**
 *  取消按钮点击事件
 */
- (void)cancelAction
{
    [self dismissAlert];
}

/**
 *  添加Alert入场动画
 *  @param alert 添加动画的view
 */
- (void)showWithAlert:(UIView *)alert
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = SHAnimationTimeInterval;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
    
}


/**
 *  添加Alert出场动画
 */
- (void)dismissAlert
{
    [UIView animateWithDuration:SHAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



/**
 *  计算字符串高度
 *  @param string 字符串
 *  @param font 字体大小
 *  @param maxSize 最大Size
 *  @return 计算得到的Size
 */
- (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}



/**
 *  添加版本更新提示
 *  @param version 版本号
 *  @param descriptions 版本更新内容（数组）
 *  description 格式如 @[@"1.xxx",@"2.xxx"]
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version descriptArray:(NSArray *)descriptions
{
    if (!descriptions || descriptions.count == 0) {
        return;
    }
    
    //数组转换字符串，动态添加换行符\n
    NSString *description = @"";
    for (NSInteger i = 0; i < descriptions.count; i++) {
        id desc = descriptions[i];
        if (![desc isKindOfClass:[NSString class]]) {
            return;
        }
        description = [description stringByAppendingString:desc];
        if (i != descriptions.count - 1) {
            description = [description stringByAppendingString:@"\n"];
        }
    }
    SHLog(@"%@", description)
    
    SHUpdateViewAlert *updateAlert = [[SHUpdateViewAlert alloc] initVersion:version description:description];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}


/**
 *  添加版本更新提示
 *  @param version 版本更新内容（数组）
 *  @param description 版本更新内容（字符串）
 *  description 格式如 @"1.xxx\n2.xxx"
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version descriptString:(NSString *)description
{
    SHUpdateViewAlert *updateAlert = [[SHUpdateViewAlert alloc] initVersion:version description:description];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}
























@end
