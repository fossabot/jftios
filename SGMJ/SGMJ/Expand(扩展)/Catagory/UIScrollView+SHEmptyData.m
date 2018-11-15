//
//  UIScrollView+SHEmptyData.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/8.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "UIScrollView+SHEmptyData.h"
#import <objc/runtime.h>

static const void * kEmptyBlock = @"emptyBlock";
static const void * kEmptyTitle = @"title";
static const void * kEmptyImage = @"imageName";
static const void * kEmptyMargin = @"contentMargin";


@implementation UIScrollView (SHEmptyData)

- (void)setEmptyBlock:(EmptyBlock)emptyBlock {
    
    objc_setAssociatedObject(self, &kEmptyBlock, emptyBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (EmptyBlock)emptyBlock {
    return objc_getAssociatedObject(self, &kEmptyBlock);
}

- (void)setTitle:(NSString *)title {
    objc_setAssociatedObject(self, &kEmptyTitle, title, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)title {
    return objc_getAssociatedObject(self, &kEmptyTitle);
}

- (void)setImageName:(NSString *)imageName {
    objc_setAssociatedObject(self, &kEmptyImage, imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)imageName {
    return objc_getAssociatedObject(self, &kEmptyImage);
}

- (void)setContentMargin:(CGFloat)contentMargin {
    NSNumber *num = [NSNumber numberWithFloat:contentMargin];
    objc_setAssociatedObject(self, &kEmptyMargin, num, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)contentMargin {
    NSNumber *num = objc_getAssociatedObject(self, &kEmptyMargin);
    return [num floatValue];
}









- (void)setupEmptyDataTitle:(NSString *)title emptyImage:(NSString *)imageName verticalMargin:(CGFloat)verticalMargin finishClick:(EmptyBlock)finish {
    
    self.emptyBlock = finish;
    self.title = title;
    self.imageName = imageName;
    self.contentMargin = contentMargin;
    
    self.emptyDataSetSource = self;
    if (finish) {
        self.emptyDataSetDelegate = self;
    }
}

- (void)whenEmptyFinishClick:(EmptyBlock)finish {
    
    [self setupEmptyDataTitle:@"暂无数据，点击刷新" emptyImage:NodataPlaceHolder verticalMargin:20.f finishClick:finish];
}


#pragma mark - empty delegate  datasource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = self.title ? :@"暂无数据";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName: SH_TitleFont,
                                 NSForegroundColorAttributeName : SH_GroupBackgroundColor,
                                 NSParagraphStyleAttributeName : paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (self.imageName) {
        return [UIImage imageNamed:self.imageName];
    }
    return [UIImage imageNamed:NodataPlaceHolder];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (!self.contentMargin) {
        return 20.f;
    }
    return self.contentMargin;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
    if (self.emptyBlock) {
        self.emptyBlock();
    }
}






@end
