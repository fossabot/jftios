//
//  SHMaskingView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMaskingView.h"
#import "SHSelectCell.h"

static NSString *identityCell = @"SHSelectCell";
@interface SHMaskingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

/** 记录选中哪个菜单按钮 */
@property (nonatomic, assign) NSInteger menuIndex;

@property (nonatomic, strong) NSMutableDictionary *status;


@end

@implementation SHMaskingView

/**
 *  懒加载
 */
- (NSMutableDictionary *)status
{
    if (!_status) {
        _status = [[NSMutableDictionary alloc] init];
    }
    return _status;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    }
    return _tableView;
}

/**
 *  初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.tableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}


- (void)getDataSource:(NSArray *)arr menuIndex:(NSInteger)menuIndex
{
    self.dataSource = [NSMutableArray arrayWithArray:arr];
    _menuIndex = menuIndex;
    [self reloadData];
}

- (void)reloadData
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.dataSource.count * 44.0;
    if (h >= self.frame.size.height) {
        h = self.frame.size.height;
    }
    self.tableView.frame = CGRectMake(0, 0, w, h);
    [self.tableView reloadData];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    cell.titleLabel.text = _dataSource[indexPath.row];
    
    if (self.status[@(_menuIndex)] == indexPath) {
        cell.titleLabel.textColor = SHColorFromHex(0xf5c144);
        cell.selectImgV.image = [UIImage imageNamed:@"choose"];
    } else {
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.selectImgV.image = [[UIImage alloc] init];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectRowBlock) {
        self.selectRowBlock(indexPath.row, _dataSource[indexPath.row]);
    }
    
    //记录选中菜单对应的indexPath
    self.status[@(_menuIndex)] = indexPath;
    [self.tableView reloadData];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/**
 *  出现
 */
- (void)show:(UIView *)superView
{
    [superView addSubview:self];
}

/**
 *  消失
 */
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
//        CGRect rect = self.tableView.frame;
//        self.tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end
