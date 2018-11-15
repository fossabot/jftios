//
//  SHMenuButtonView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMenuButtonView.h"
#import "SHDownMenuListView.h"
#import "SHMaskingView.h"

@interface SHMenuButtonView ()

/**
 *  菜单按钮
 */
@property (nonatomic, strong) NSMutableArray *menuButtons;
/**
 *  菜单文字
 */
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) SHDownMenuListView *listView;

/**
 *  选中button
 */
@property (nonatomic, strong) UIButton *selectBtn;

@end


@implementation SHMenuButtonView

- (SHDownMenuListView *)listView
{
    if (!_listView) {
        _listView = [[SHDownMenuListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), SHScreenW, SHScreenH - CGRectGetHeight(self.frame) - 64)];
        SHWeakSelf
        [_listView setDismissBlock:^{
            //改变遮罩改变button状态
            //还原默认颜色
            [weakSelf.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            weakSelf.selectBtn.selected = NO;
            [weakSelf.selectBtn setImage:[UIImage imageNamed:@"searchNoselect"] forState:UIControlStateNormal];
        }];
    }
    return _listView;
}

- (NSMutableArray *)menuButtons
{
    if (!_menuButtons) {
        _menuButtons = [[NSMutableArray alloc] init];
    }
    return _menuButtons;
}

- (instancetype)initWithFrame:(CGRect)frame menuTitle:(NSArray *)menuTitles
{
    self = [super initWithFrame:frame];
    if (self) {
        _menuTitles = menuTitles;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    if (!_menuTitles.count) {
        return;
    }
    for (NSInteger i = 0; i < _menuTitles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SHScreenW / 2 * i, 0, SHScreenW / 2, 40)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [btn setTitle:_menuTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = SH_FontSize(14.0);
        [btn addTarget:self action:@selector(didSelectMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *imgArrow = [UIImage imageNamed:@"searchNoselect"];
        [btn setImage:imgArrow forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        /* 获取按钮文字的宽度 获取按钮图片和文字的间距 获取图片宽度 */
        CGFloat    space = 5;// 图片和文字的间距
        NSString    * titleString = _menuTitles[i];
        CGFloat    titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        UIImage    * btnImage = [UIImage imageNamed:@"outspread"];// 11*6
        CGFloat    imageWidth = btnImage.size.width;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5))];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*5))];

        [self addSubview:btn];
        
        [self.menuButtons addObject:btn];
    }
    UIView *lineL = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, SHScreenW, 0.5)];
    lineL.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineL];
}

- (void)setListTitles:(NSArray<NSArray *> *)listTitles
{
    _listTitles = listTitles;
}

#pragma mark - 菜单按钮点击事件
- (void)didSelectMenuButton:(UIButton *)button
{
    SHLog(@"did点击")
    [self.superview addSubview:self.listView];
    
    if (self.selectBtn == button) {
        self.selectBtn.selected = !self.selectBtn.selected;
    } else {
        // 还原默认颜色
        [self.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"searchNoselect"] forState:UIControlStateNormal];
        self.selectBtn.selected = NO;
        self.selectBtn = button;
        self.selectBtn.selected = YES;
        
    }
    
    
    if (self.selectBtn.selected) {
        [button setTitleColor:navColor forState:UIControlStateNormal];
        //[button setTitle:self.title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"searchSelect"] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"searchNoselect"] forState:UIControlStateNormal];
        [self.listView.maskingView dismiss];
    }
    
    NSInteger index = button.tag;
    [self.listView.maskingView getDataSource:_listTitles[index] menuIndex:index];
    SHWeakSelf
    [self.listView.maskingView setSelectRowBlock:^(NSInteger row, NSString *rowTitle) {
        if ([weakSelf.delegate respondsToSelector:@selector(sh_menuButton:didSelectMenuButtonAtIndex:selectMenuButtonTitle:listRow:rowTitle:)]) {
            [weakSelf.delegate sh_menuButton:weakSelf didSelectMenuButtonAtIndex:index selectMenuButtonTitle:button.currentTitle listRow:row rowTitle:rowTitle];
            [button setTitle:rowTitle forState:UIControlStateNormal];
            
            /* 获取按钮文字的宽度 获取按钮图片和文字的间距 获取图片宽度 */
            CGFloat    space = 5;// 图片和文字的间距
            NSString    * titleString = rowTitle;
            CGFloat    titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
            UIImage    * btnImage = [UIImage imageNamed:@"outspread"];// 11*6
            CGFloat    imageWidth = btnImage.size.width;
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5))];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*5))];
            [weakSelf.listView.maskingView dismiss];
            
            if (weakSelf.listView.dismissBlock) {
                weakSelf.listView.dismissBlock();
            }
            
        }
    }];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = SHScreenW / self.menuButtons.count;
    CGFloat h = self.bounds.size.height;
    for (NSInteger i = 0; i < self.menuButtons.count; i++) {
        UIButton *btn = (UIButton *)self.menuButtons[i];
        btn.frame = CGRectMake(i * w, 0, w, h);
    }
    
}


@end














