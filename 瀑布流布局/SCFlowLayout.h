//
//  SCFlowLayout.h
//  瀑布流布局
//
//  Created by 石川 on 2020/1/10.
//  Copyright © 2020 石川. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SCFlowLayout;
@protocol SCFlowLayoutDelegate <NSObject>

@required
/**
 * 每个item的高度
 */
- (CGFloat)waterFallLayout:(SCFlowLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;
@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInWaterFallLayout:(SCFlowLayout *)waterFallLayout;

/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInWaterFallLayout:(SCFlowLayout *)waterFallLayout;

/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInWaterFallLayout:(SCFlowLayout *)waterFallLayout;

/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(SCFlowLayout *)waterFallLayout;


@end

@interface SCFlowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<SCFlowLayoutDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
