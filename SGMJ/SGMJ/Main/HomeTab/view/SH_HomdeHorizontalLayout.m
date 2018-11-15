//
//  SH_HomdeHorizontalLayout.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/11/5.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SH_HomdeHorizontalLayout.h"

@interface SH_HomdeHorizontalLayout ()<UICollectionViewDelegateFlowLayout>


// item总数
@property (nonatomic, assign) NSInteger itemCountTotal;
// 页数
@property (nonatomic, assign) NSInteger pageCount;
// 最大行数
@property (nonatomic, assign) NSInteger maxRowCount;

@property (strong, nonatomic) NSMutableArray *allAttributes;

@property (nonatomic, copy) NSMutableDictionary *sectionDic;

@end

@implementation SH_HomdeHorizontalLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _headerSize = CGSizeZero;
        _footerSize = CGSizeZero;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    _sectionDic = [NSMutableDictionary dictionary];
    self.allAttributes = [NSMutableArray array];
    //获取section的数量
    NSUInteger section = [self.collectionView numberOfSections];
    
    for (int sec = 0; sec < section; sec++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:sec];
        
        UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        headerAttr.frame = CGRectMake(sec*SHScreenW, 0, self.headerSize.width, self.headerSize.height);
        
        UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        footerAttr.frame = CGRectMake((sec+1)*SHScreenW-self.footerSize.width, 0, self.footerSize.width, self.footerSize.height);
        
        [self.allAttributes addObject:headerAttr];
        [self.allAttributes addObject:footerAttr];
        
        //获取每个section的cell个数
        NSUInteger count = [self.collectionView numberOfItemsInSection:sec];
        
        for (NSUInteger item = 0; item<count; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:sec];
            //重新排列
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.allAttributes addObject:attributes];
            
        }
    }
    
}

- (CGSize)collectionViewContentSize
{
    
    //每个section的页码的总数
    NSInteger actualLo = 0;
    for (NSString *key in [_sectionDic allKeys]) {
        actualLo += [_sectionDic[key] integerValue];
    }
    
    
    return CGSizeMake(actualLo*self.collectionView.frame.size.width, self.collectionView.contentSize.height);
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    
    if(attributes.representedElementKind != nil)
    {
        return;
    }

    /*修改by lixinkai 2017.6.30
     下面这两个方法 itemW、itemH
     解决了同一个UICollectionView使用不同UICollectionViewCell的问题
     */
    //attributes 的宽度
    CGFloat itemW = attributes.frame.size.width;
    //attributes 的高度
    CGFloat itemH = attributes.frame.size.height;
    
    //collectionView 的宽度
    CGFloat width = self.collectionView.frame.size.width;
    //collectionView 的高度
    CGFloat height = self.collectionView.frame.size.height;
    //每个attributes的下标值 从0开始
    NSInteger itemIndex = attributes.indexPath.item;
    
    CGFloat stride = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? width : height;
    
    
    //获取现在的attributes是第几组
    NSInteger section = attributes.indexPath.section;
    //获取每个section的item的个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    
    
    CGFloat offset = section * stride;
    
    //计算x方向item个数
//    NSInteger xCount = (width / itemW);
    NSInteger xCount = self.itemCountPerRow;
    
    //计算y方向item个数
//    NSInteger yCount = (height / itemH);
    NSInteger yCount = self.rowCount;
    
    //计算一页总个数
    NSInteger allCount = (xCount * yCount);
    //获取每个section的页数，从0开始
    NSInteger page = itemIndex / allCount;
    
    //余数，用来计算item的x的偏移量
    NSInteger remain = (itemIndex % xCount);
    
    //取商，用来计算item的y的偏移量
    NSInteger merchant = (itemIndex-page*allCount)/xCount;
    
    
    //x方向每个item的偏移量
    CGFloat xCellOffset = self.sectionInset.left + remain * (itemW + self.minimumLineSpacing);
    //y方向每个item的偏移量
    CGFloat yCellOffset = self.sectionInset.top + merchant * (itemH + self.minimumInteritemSpacing);
    
    
    //获取每个section中item占了几页
    NSInteger pageRe = (itemCount % allCount == 0)? (itemCount / allCount) : (itemCount / allCount) + 1;
    //将每个section与pageRe对应，计算下面的位置
    [_sectionDic setValue:@(pageRe) forKey:[NSString stringWithFormat:@"%ld", section]];
    
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        NSInteger actualLo = 0;
        //将每个section中的页数相加
        for (NSString *key in [_sectionDic allKeys]) {
            actualLo += [_sectionDic[key] integerValue];
        }
        //获取到的最后的数减去最后一组的页码数
        actualLo -= [_sectionDic[[NSString stringWithFormat:@"%ld", [_sectionDic allKeys].count-1]] integerValue];
        xCellOffset += page*width + actualLo*width;
        
    } else {
        
        yCellOffset += offset;
    }
    
    attributes.frame = CGRectMake(xCellOffset, yCellOffset, itemW, itemH);
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    
    [self applyLayoutAttributes:attr];
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.allAttributes;
}






/*
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.allAttributes = [NSMutableArray array];
//        self.maxRowCount = 2;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}



- (void)prepareLayout {
    
    [super prepareLayout];

    self.allAttributes = [NSMutableArray array];

    
    NSInteger sections = [self.collectionView numberOfSections];
    
    for (int i = 0; i < sections; i++)
    
        {
        
                NSMutableArray * tmpArray = [NSMutableArray array];
        
                NSUInteger count = [self.collectionView numberOfItemsInSection:i];
        
                for (NSUInteger j = 0; j<count; j++) {
            
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
                        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            
                        [tmpArray addObject:attributes];
            
                    }
        
                [self.allAttributes addObject:tmpArray];
            }
    
}



- (CGSize)collectionViewContentSize {

//    NSInteger total = self.rowCount * self.itemCountPerRow;
//
//    NSInteger pages = ceil(self.allAttributes.count / (float)total);
//
//    CGSize size = CGSizeMake(CGRectGetWidth(self.collectionView.frame)*pages, 1);
    
//    SHLog(@"size  ---  %@,  supersize  ---  %@",NSStringFromCGSize(size),NSStringFromCGSize([super collectionViewContentSize]));
//    return size;
    return [super collectionViewContentSize];
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger item = indexPath.item;

    NSUInteger x;

    NSUInteger y;
    
    [self targetPositionWithItem:item resultX:&x resultY:&y];

    
    //找到这个item设想中应在的位置，然后拿到那个位置的indexpath，并将布局属性的indexpath值赋值为当前item的indexpath
    NSUInteger shouldPlacedItem = [self originItemAtX:x y:y];

    NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForItem:shouldPlacedItem inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *theNewAttr = [super layoutAttributesForItemAtIndexPath:theNewIndexPath];

    theNewAttr.indexPath = indexPath;

    return theNewAttr;
    
}



- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    NSMutableArray *tmp = [NSMutableArray array];

    for (UICollectionViewLayoutAttributes *attr in attributes) {
    
            for (NSMutableArray *attributes in self.allAttributes)
        
                {
            
                    for (UICollectionViewLayoutAttributes *attr2 in attributes) {
            
                            if (attr.indexPath.item == attr2.indexPath.item) {
                
                                    [tmp addObject:attr2];
                
                                    break;
                                }
                        }
            
                    }
    
        }

    return tmp;
    
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



// 根据 item 计算目标设想中item的位置

// x 横向偏移  y 竖向偏移

- (void)targetPositionWithItem:(NSUInteger)item resultX:(NSUInteger *)x resultY:(NSUInteger *)y
{
    
    
    NSUInteger page = item / (self.itemCountPerRow * self.rowCount);

    NSUInteger theX = item % self.itemCountPerRow + page * self.itemCountPerRow;

    NSUInteger theY = item / self.itemCountPerRow - page * self.rowCount;

    SHLog(@" 每行个数  -- %ld, item  --  %ld,  page  --  %ld,  theX  --  %ld,  theY  --  %ld",self.itemCountPerRow,item,page,theX,theY);
    
    if (x != NULL) {
    
            *x = theX + (page*self.itemCountPerRow);
        }

    if (y != NULL) {
    
            *y = theY;
        }
    
}



// 根据偏移量计算item

- (NSUInteger)originItemAtX:(NSUInteger)x y:(NSUInteger)y

{
    
    NSUInteger item = x * self.rowCount + y;
    SHLog(@"每行个数  -- %ld, 新的item  ----  %ld",self.itemCountPerRow,item);
    return item;
}

 */






@end

