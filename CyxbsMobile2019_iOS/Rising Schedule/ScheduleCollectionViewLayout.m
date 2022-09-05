//
//  ScheduleCollectionViewLayout.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewLayout.h"

#pragma mark - ScheduleCollectionViewLayout ()

@interface ScheduleCollectionViewLayout ()

/// 获取section的值
@property (nonatomic) NSInteger sections;

/// 正常视图每一小节课的大小
@property (nonatomic) CGSize itemSize;

/// 正常视图布局
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *attributes;

/// 补充视图布局
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *> *supplementaryAttributes;

@end

#pragma mark - ScheduleCollectionViewLayout

@implementation ScheduleCollectionViewLayout

#pragma mark - UICollectionViewLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *result = NSMutableArray.array;
    
    for (NSInteger section = 0; section < self.sections; section++) {
        NSUInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [result addObject:attributes];
            }
        }
    }
    
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    
    UICollectionViewLayoutAttributes *attributes = _attributes[indexPath];
    if (attributes != nil) {
        return attributes;
    }

    attributes = [self.class.layoutAttributesClass layoutAttributesForCellWithIndexPath:indexPath];
    
    if (self.delegate) {
        NSUInteger section = indexPath.section;
        NSUInteger week = [self.delegate collectionView:self.collectionView layout:self weekForItemAtIndexPath:indexPath];
        NSRange range = [self.delegate collectionView:self.collectionView layout:self rangeForItemAtIndexPath:indexPath];
        
        CGFloat x = section * self.collectionView.bounds.size.width + self.widthForLeadingSupplementaryView + (week - 1) * (self.itemSize.width + self.columnSpacing);
        CGFloat y = self.heightForTopSupplementaryView + (range.location - 1) * (self.itemSize.height + self.lineSpacing);
        CGFloat height = range.length * self.itemSize.height + (range.length - 1) * self.columnSpacing;
        
        CGRect frame = CGRectMake(x, y, self.itemSize.width, height);
        
        attributes.frame = frame;
    }
    
    _attributes[indexPath] = attributes;
    
    return attributes;
}

- (CGSize)collectionViewContentSize {
    
    NSInteger itemCount = 12;
    
    CGSize contentSize = CGSizeMake(self.sections * self.collectionView.bounds.size.width, self.heightForTopSupplementaryView + itemCount * (self.itemSize.height + self.lineSpacing));
    
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [self _calculateLayoutIfNeeded];
}

#pragma mark - Private API

- (void)_calculateLayoutIfNeeded {
    
    self.sections = [self.collectionView.dataSource performSelector:@selector(numberOfSectionsInCollectionView:)]
    ? [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView]
    : [self.collectionView numberOfSections];
    
    CGFloat width = (self.collectionView.bounds.size.width - self.widthForLeadingSupplementaryView) / 7 - self.columnSpacing;
    
    self.itemSize = CGSizeMake(width, width / 46 * 50);
}

@end
