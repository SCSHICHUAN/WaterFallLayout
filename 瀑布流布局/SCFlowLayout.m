//
//  SCFlowLayout.m
//  瀑布流布局
//
//  Created by 石川 on 2020/1/10.
//  Copyright © 2020 石川. All rights reserved.
//
#import "SCFlowLayout.h"
/*默认的列数*/
static const CGFloat DefaultColunmCount = 2;
/*每一列之间的间距*/
static const CGFloat DefaultColunmMargin = 10;
/*每一行之间的间距*/
static const CGFloat DefaultRowMargin = 10;
/*内边距*/
static const UIEdgeInsets DefaultEdgeInsets = {10,10,10,10};



@interface SCFlowLayout()
/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray * attrsArr;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

/*获取代理发回的数据*/
- (NSUInteger)colunmCount;
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (UIEdgeInsets)edgeInsets;

@end

@implementation SCFlowLayout

#pragma mark-默认布局
/**
 * 列数
 */
- (NSUInteger)colunmCount{
    
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFallLayout:)]) {
        return [self.delegate columnCountInWaterFallLayout:self];
    }else{
        return DefaultColunmCount;
    }
}
/**
 * 列间距
 */
- (CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFallLayout:)]) {
        return [self.delegate columnMarginInWaterFallLayout:self];
    }else{
        return DefaultColunmMargin;
    }
}
/**
 * 行间距
 */
- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFallLayout:)]) {
        return [self.delegate rowMarginInWaterFallLayout:self];
    }else{
        return DefaultRowMargin;
    }
}
/**
 * item的内边距
 */
- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetdInWaterFallLayout:)]) {
        return [self.delegate edgeInsetdInWaterFallLayout:self];
    }else{
        return DefaultEdgeInsets;
    }
}

#pragma mark-准备布局
/**
 * 初始化
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 清楚之前计算的所有高度
    [self.columnHeights removeAllObjects];
    // 设置每一列默认的高度
    for (NSInteger i = 0; i < self.colunmCount; i ++) {
        [self.columnHeights addObject:@(DefaultEdgeInsets.top)];
    }
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    // 清楚之前所有的布局属性
    [self.attrsArr removeAllObjects];
    for (int i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 获取indexPath位置上cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArr addObject:attrs];
    }
    
}

#pragma mark-rewrite
/**
 * 决定cell的高度
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArr;
}
/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    CGFloat cellW = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.colunmCount - 1) * self.columnMargin) / self.colunmCount;
    /*
     从代理或每个cell的高度
     */
    CGFloat cellH = [self.delegate waterFallLayout:self heightForItemAtIndexPath:indexPath.item itemWidth:cellW];
    // 找出最短的那一列
       NSInteger destColumn = 0;
       CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
       
       for (int i = 1; i < self.colunmCount; i++) {
           
           // 取得第i列的高度
           CGFloat columnHeight = [self.columnHeights[i] doubleValue];
           
           if (minColumnHeight > columnHeight) {
               minColumnHeight = columnHeight;
               destColumn = i;
           }
       }
       
       CGFloat cellX = self.edgeInsets.left + destColumn * (cellW + self.columnMargin);
       CGFloat cellY = minColumnHeight;
       if (cellY != self.edgeInsets.top) {
           
           cellY += self.rowMargin;
       }
       
       attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
       
       // 更新最短那一列的高度
       self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
       
       // 记录内容的高度 - 即最长那一列的高度
       CGFloat maxColumnHeight = [self.columnHeights[destColumn] doubleValue];
       if (self.contentHeight < maxColumnHeight) {
           self.contentHeight = maxColumnHeight;
       }
       
       return attrs;
    
    return nil;
}
/**
 * 内容的高度
 */
- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}
#pragma mark 懒加载
- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

@end
