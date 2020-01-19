//
//  WaterFallLayout.m
//  UICollectionView
//
//  Created by 方昱恒 on 2020/1/18.
//  Copyright © 2020 方昱恒. All rights reserved.
//

#import "WaterFallLayout.h"

@interface WaterFallLayout ()

/** 保存所有Item的LayoutAttributes */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
/** 保存所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeights;

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) NSUInteger columns;

@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) CGFloat cellWidth;

@end



@implementation WaterFallLayout

- (CGFloat)margin {
    return 17;
}

- (CGFloat)cellWidth {
    return (MAIN_SCREEN_W - (2 * self.margin) - self.itemSpacing) / 2.0;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.columns = 2;
        self.itemSpacing = 10;
        self.attributesArray = [NSMutableArray array];
        self.columnHeights = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.columnHeights removeAllObjects];
    
    for (int i = 0; i < self.columns; i++) {
        [self.columnHeights addObject:@(0)];
    }
    
    [self.attributesArray removeAllObjects];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attrs];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat x;
    CGFloat y;
    CGFloat w;
    CGFloat h;
    
    if (indexPath.item == 0) {
        x = self.margin;
        y = self.itemSpacing;
        w = self.cellWidth;
        h = self.cellWidth * 1.42;
        attrs.frame = CGRectMake(x, y, w, h);
    } else if (indexPath.item == 1) {
        x = self.margin + self.cellWidth + self.itemSpacing;
        y = self.itemSpacing;
        w = self.cellWidth;
        h = self.cellWidth * 1.946;
        attrs.frame = CGRectMake(x, y, w, h);
    } else {
        if (indexPath.item % 2 == 0) {       // item在左边一列
            x = self.margin;
            y = self.columnHeights[0].doubleValue + self.itemSpacing;
            w = self.cellWidth;
            h = self.cellWidth * 1.42;
            attrs.frame = CGRectMake(x, y, w, h);
        } else {                            // item在右边一列
            x = self.margin + self.cellWidth + self.itemSpacing;
            y = self.columnHeights[1].doubleValue + self.itemSpacing;
            w = self.cellWidth;
            h = self.cellWidth * 1.42;
            attrs.frame = CGRectMake(x, y, w, h);
        }
    }
    
    // 更新列高
    if (indexPath.item % 2 ==0) {       // item在左边一列
        self.columnHeights[0] = @(h + y);
        self.contentHeight = self.columnHeights[0].doubleValue;
    } else {                            // item在右边一列
        self.columnHeights[1] = @(h + y);
        self.contentHeight = self.columnHeights[1].doubleValue;
    }
    
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}



- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.contentHeight + self.margin);
}

@end
