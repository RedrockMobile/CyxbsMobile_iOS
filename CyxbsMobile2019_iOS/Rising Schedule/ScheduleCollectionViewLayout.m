//
//  ScheduleCollectionViewLayout.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewLayout.h"

#pragma mark - ScheduleCollectionViewLayoutInvalidationContext

@interface ScheduleCollectionViewLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext

/// 是否立刻重新布局顶视图
@property (nonatomic) BOOL invalidateHeaderSupplementaryAttributes;

/// 是否立刻重新布局左视图
@property (nonatomic) BOOL invalidateLeadingSupplementaryAttributes;

/// 是否立刻重新布局课表视图
@property (nonatomic) BOOL invalidateItemAttributes;

@end

#pragma mark - ScheduleCollectionViewLayoutInvalidationContext

@implementation ScheduleCollectionViewLayoutInvalidationContext

@end

#pragma mark - ScheduleCollectionViewLayout ()

@interface ScheduleCollectionViewLayout ()

/// 获取section的值
@property (nonatomic) NSInteger sections;

/// 正常视图每一小节课的大小
@property (nonatomic) CGSize itemSize;

/// 正常视图布局
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *itemAttributes;

/// 补充视图布局
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *> *supplementaryAttributes;

@end

#pragma mark - ScheduleCollectionViewLayout

@implementation ScheduleCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemAttributes = NSMutableDictionary.dictionary;
        _supplementaryAttributes = @{
            UICollectionElementKindSectionHeader : NSMutableDictionary.dictionary,
            UICollectionElementKindSectionLeading : NSMutableDictionary.dictionary
        }.mutableCopy;
    }
    return self;
}

#pragma mark - LayoutAttributes

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *result = NSMutableArray.array;
    
    for (NSInteger section = 0; section < self.sections; section++) {
        // SupplementaryView attributes
        for (NSString *elementKind in _supplementaryAttributes.allKeys) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [result addObject:attributes];
            }
        }
        // Cell attributes
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
    
    UICollectionViewLayoutAttributes *attributes = _itemAttributes[indexPath];
    if (attributes) {
        return attributes;
    }

    attributes = [self.class.layoutAttributesClass layoutAttributesForCellWithIndexPath:indexPath];
    
    if (self.delegate) {
        NSUInteger section = indexPath.section;
        NSUInteger week = [self.delegate collectionView:self.collectionView layout:self weekForItemAtIndexPath:indexPath];
        NSRange range = [self.delegate collectionView:self.collectionView layout:self rangeForItemAtIndexPath:indexPath];
        
        CGFloat x = section * self.collectionView.bounds.size.width + self.widthForLeadingSupplementaryView + (week - 1) * (self.itemSize.width + self.columnSpacing);
        CGFloat y = self.heightForHeaderSupplementaryView + (range.location - 1) * (self.itemSize.height + self.lineSpacing);
        CGFloat height = range.length * self.itemSize.height + (range.length - 1) * self.columnSpacing;
        
        CGRect frame = CGRectMake(x, y, self.itemSize.width, height);
        
        attributes.frame = frame;
    }
    
    _itemAttributes[indexPath] = attributes;
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    
    UICollectionViewLayoutAttributes *attributes = _supplementaryAttributes[elementKind][indexPath];

    if (attributes) {
        return attributes;
    }
    
    attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    _supplementaryAttributes[elementKind][indexPath] = attributes;
    // Header Element
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGFloat x = indexPath.section * self.collectionView.width;
        CGFloat y = self.collectionView.contentOffset.y;
        
        CGRect frame = CGRectMake(x, y, self.collectionView.width, self.heightForHeaderSupplementaryView);
        
        attributes.frame = frame;
        
        return attributes;
    }
    // Leading Element
    if ([elementKind isEqualToString:UICollectionElementKindSectionLeading]) {
        CGFloat x = indexPath.section * self.collectionView.width;
        CGFloat height = (self.itemSize.height + self.lineSpacing) * 12;
        
        CGRect frame = CGRectMake(x, self.heightForHeaderSupplementaryView, self.widthForLeadingSupplementaryView, height);
        
        attributes.frame = frame;
        
        return attributes;
    }
    
    return attributes;
}

#pragma mark - Others

- (CGSize)collectionViewContentSize {
    
    NSInteger itemCount = 12;
    
    CGSize contentSize = CGSizeMake(self.sections * self.collectionView.bounds.size.width, self.heightForHeaderSupplementaryView + itemCount * (self.itemSize.height + self.lineSpacing));
    
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [self _calculateLayoutIfNeeded];
}

#pragma mark - LayoutInvalidationContext

+ (Class)invalidationContextClass {
    return ScheduleCollectionViewLayoutInvalidationContext.class;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
    
    ScheduleCollectionViewLayoutInvalidationContext *context =
    (ScheduleCollectionViewLayoutInvalidationContext *)[super invalidationContextForBoundsChange:newBounds];
    
    context.invalidateHeaderSupplementaryAttributes = YES;
    
    return context;
}

- (void)invalidateLayoutWithContext:(ScheduleCollectionViewLayoutInvalidationContext *)context {
    
    // invalidate Header Supplementary
    if (context.invalidateHeaderSupplementaryAttributes) {
        
        [_supplementaryAttributes[UICollectionElementKindSectionHeader] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, UICollectionViewLayoutAttributes * _Nonnull attributes, BOOL * __unused stop) {
            
            CGFloat x = indexPath.section * self.collectionView.width;
            CGFloat y = self.collectionView.contentOffset.y;
            
            CGRect frame = CGRectMake(x, y, self.collectionView.width, self.heightForHeaderSupplementaryView);
            
            attributes.frame = frame;
        }];
    }
    
    // invalidate Leading Supplementary
    if (context.invalidateLeadingSupplementaryAttributes) {
        
        [_supplementaryAttributes[UICollectionElementKindSectionLeading] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, UICollectionViewLayoutAttributes * _Nonnull attributes, BOOL * __unused stop) {
            
            CGFloat x = indexPath.section * self.collectionView.width;
            CGFloat height = (self.itemSize.height + self.lineSpacing) * 12;
            
            CGRect frame = CGRectMake(x, self.heightForHeaderSupplementaryView, self.widthForLeadingSupplementaryView, height);
            
            attributes.frame = frame;
        }];
    }
    
    // invalidate All Attributes
    if (context.invalidateItemAttributes) {
        
        [_itemAttributes removeAllObjects];
        
        [_supplementaryAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * __unused key, NSMutableDictionary<NSIndexPath *,UICollectionViewLayoutAttributes *> * _Nonnull obj, BOOL * __unused stop) {
            
            [obj removeAllObjects];
        }];
    }
    
    [super invalidateLayoutWithContext:context];
}

#pragma mark - Private API

- (void)_calculateLayoutIfNeeded {
    
    _sections = [self.collectionView.dataSource performSelector:@selector(numberOfSectionsInCollectionView:) withObject:self.collectionView]
    ? [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView]
    : [self.collectionView numberOfSections];
    
    CGFloat width = (self.collectionView.bounds.size.width - self.widthForLeadingSupplementaryView) / 7 - self.columnSpacing;
    
    _itemSize = CGSizeMake(width, width / 46 * 50);
}

@end
