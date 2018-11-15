//
//  SH_HomeBannerTableViewCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_HomeBannerTableViewCell.h"
#import "SDCycleScrollView.h"


@interface SH_HomeBannerTableViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIView *bottomView;

@end


@implementation SH_HomeBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.contentView);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = SH_WhiteColor;
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(5);
    }];
    
}

#pragma mark - SDCycleScrolView delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    SHLog(@"点击了banner SDCycleScrollView的第%ld页",index);
    if (_selectBlock) {
        _selectBlock(index);
    }
}


#pragma mark - setter

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    self.bannerView.imageURLStringsGroup = dataSource;
}

#pragma mark - private method

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.bottomView.ba_viewCornerRadius = 5;
    self.bottomView.ba_viewRectCornerType = BAKit_ViewRectCornerTypeTopLeftAndTopRight;
}

#pragma mark - lazy method


- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        _bannerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, SHScreenW*moduleRatio)];
        _bannerView.delegate = self;
        _bannerView.currentPageDotImage = [UIImage imageNamed:@"dotActive"];
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _bannerView.pageDotImage = [UIImage imageNamed:@"dotInactive"];
        //设置图片视图显示类型
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        //滚动视图间隔
        _bannerView.autoScrollTimeInterval = 3.0;
        //设置轮播视图的分页控件的显示
        _bannerView.showPageControl = YES;
        //设置轮播图分页控件的位置
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.pageControlBottomOffset = 10.f;
    }
    return _bannerView;
}


@end
