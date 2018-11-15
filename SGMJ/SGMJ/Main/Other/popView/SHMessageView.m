//
//  SHMessageView.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHMessageView.h"
#import "SHMenuTableViewCell.h"


#define kHEMenuTableCell @"SHMenuTableViewCell"
#define YHSafeAreaTopHeight (YHkHeight == 812.f ? 88.f : 64.f)
#define YHkWidth [UIScreen mainScreen].bounds.size.width
#define YHkHeight [UIScreen mainScreen].bounds.size.height
#define kTriangleHeight 10.f //底的1/2倍
#define kTriangleToHeight 10.f  // 三角形的高,
#define kItemHeight 40.f       // item 高

@implementation SHMessageView

- (NSMutableArray *)titleSource
{
    if (!_titleSource) {
        self.titleSource = [NSMutableArray array];
    }
    return _titleSource;
}


- (NSMutableArray *)imgSource
{
    if (!_imgSource) {
        self.imgSource = [NSMutableArray array];
    }
    return _imgSource;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = ({
            UITableView *tableView = [UITableView new];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[SHMenuTableViewCell class] forCellReuseIdentifier:kHEMenuTableCell];
            tableView.tableFooterView = [UIView new];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.layer.cornerRadius = 10;
            tableView.clipsToBounds = YES;
            tableView;
        });
    }
    return _tableView;
}

#pragma mark - 生命周期
- (id)initWithFrame:(CGRect)frame menuWidth:(CGFloat)width height:(CGFloat)height point:(CGPoint)point items:(NSArray *)items imgSource:(NSArray *)imgSource action:(void (^)(NSInteger))action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.point = CGPointMake(point.x, YHSafeAreaTopHeight + point.y);
        self.layerWidth = width;
        [self.titleSource removeAllObjects];
        [self.titleSource addObjectsFromArray:items];
        [self.imgSource removeAllObjects];
        [self.imgSource addObjectsFromArray:imgSource];
        if (_imgSource.count != _titleSource.count) {
            [_imgSource removeAllObjects];
        }
        if (imgSource.count == 0) {
            self.layerWidth = 100;
        }
        __weak typeof(self)weakSelf = self;
        if (action) {
            weakSelf.indexBlock = ^(NSInteger row) {
                action(row);
            };
        }
        self.layerHeight = _titleSource.count > 2 ? height : items.count*kItemHeight;
        [self addSubview:self.tableView];
        CGFloat y1 = self.point.y + kTriangleHeight;
        CGFloat x2 = self.point.x - self.layerWidth + kTriangleHeight +kTriangleHeight;
        _tableView.frame = CGRectMake(x2, y1, self.layerWidth, self.layerHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect

{
    
    CGFloat y1 = self.point.y + kTriangleHeight;
    CGFloat y2 = y1 + self.layerHeight;
    CGFloat x1 = self.point.x - kTriangleHeight;
    CGFloat x2 = self.point.x - self.layerWidth + kTriangleHeight +kTriangleToHeight;
    CGFloat x3 = self.point.x + kTriangleHeight +kTriangleToHeight;
    CGFloat x4 = self.point.x + kTriangleHeight;
    
    // 设置背景色
    [[UIColor clearColor] set];
    //拿到当前视图准备好的画板
    CGContextRef  context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    // 起始点1
    CGContextMoveToPoint(context, self.point.x, self.point.y);//设置起点
    // 起始点2
    CGContextAddLineToPoint(context, x1, y1);
    // table左上角
    CGContextAddLineToPoint(context, x2, y1+10);
    // table左下角
    CGContextAddLineToPoint(context, x2, y2-10);
    // table 右下角
    CGContextAddLineToPoint(context, x3, y2-10);
    // table 右上角
    CGContextAddLineToPoint(context, x3-10, y1);
    // 起始点2
    CGContextAddLineToPoint(context,x4, y1);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [[UIColor whiteColor] setFill];  //设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SHMenuTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kHEMenuTableCell width:self.layerWidth height:kItemHeight];
    }
    
    if (indexPath.row == 0) {
        cell.lineView.hidden = YES;
    }
    [cell setContentByTitArray:self.titleSource ImgArray:self.imgSource row:indexPath.row];
    cell.conLabel.text = self.titleSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.indexBlock) {
        self.indexBlock(indexPath.row);
    }
}










- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchBlock) {
        self.touchBlock();
    }
}







@end
