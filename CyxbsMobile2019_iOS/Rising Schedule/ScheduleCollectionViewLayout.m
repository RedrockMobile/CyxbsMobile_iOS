//
//  ScheduleCollectionViewLayout.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewLayout.h"

#pragma mark - ScheduleCollectionViewLayout ()

@interface ScheduleCollectionViewLayout () <UICollectionViewDelegateFlowLayout>

/// 获取section的值
@property (nonatomic) NSInteger sections;

/// 正常视图每一小节课的大小
@property (nonatomic) CGSize itemSize;

/// 正常视图布局
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, ScheduleCollectionViewLayoutAttributes *> *itemAttributes;

/// 补充视图布局
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *> *supplementaryAttributes;

@end

#pragma mark - ScheduleCollectionViewLayout

@implementation ScheduleCollectionViewLayout {
    NSMutableDictionary <NSNumber *, NSMutableArray <ScheduleCollectionViewLayoutAttributes *> *> * _autoItemAttributes;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemAttributes = NSMutableDictionary.dictionary;
        _supplementaryAttributes = @{
            UICollectionElementKindSectionHeader : NSMutableDictionary.dictionary,
            UICollectionElementKindSectionLeading : NSMutableDictionary.dictionary
        }.mutableCopy;
        _autoItemAttributes = NSMutableDictionary.dictionary;
    }
    return self;
}

#pragma mark - Ask LayoutAttributes

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = NSMutableArray.array;
    for (NSInteger section = 0; section < _sections; section++) {
        
        // SupplementaryView attributes
        for (NSString *elementKind in _supplementaryAttributes.allKeys) {
            
            NSInteger supplementaryCount = [self.dataSource collectionView:self.collectionView layout:self numberOfSupplementaryOfKind:elementKind inSection:section];
            for (NSInteger item = 0; item < supplementaryCount; item++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
                if (CGRectIntersectsRect(rect, attributes.frame)) {
                    [result addObject:attributes];
                }
            }
        }
        
        // Cell attributes
        NSUInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [result addObject:attributes];
            }
        }
    }
    
    return result;
}

// --------------- Item ---------------

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    
    ScheduleCollectionViewLayoutAttributes *attributes = _itemAttributes[indexPath];
    if (attributes) {
        NSAssert(attributes.layoutModel.week, @"week为0");
        return attributes;
    }

    attributes = [self.class.layoutAttributesClass layoutAttributesForCellWithIndexPath:indexPath];
    _itemAttributes[indexPath] = attributes;
    
    if (self.dataSource) {
        ScheduleCollectionViewLayoutModel *viewModel = [self.dataSource collectionView:self.collectionView layout:self layoutModelForItemAtIndexPath:indexPath];
        
        attributes.layoutModel = viewModel;
        
        [self _transformItemWithAttributes:attributes];
    }
    
    return attributes;
}

- (void)_transformItemWithAttributes:(ScheduleCollectionViewLayoutAttributes *)attributes {
    ScheduleCollectionViewLayoutModel *layoutModel = attributes.layoutModel;
    
    CGFloat x = attributes.indexPath.section * self.collectionView.width + self.widthForLeadingSupplementaryView + (layoutModel.week - 1) * (_itemSize.width + self.columnSpacing);
    CGFloat y = self.heightForHeaderSupplementaryView + (layoutModel.orginRange.location - 1) * (_itemSize.height + self.lineSpacing);
    CGFloat height = layoutModel.orginRange.length * _itemSize.height + (layoutModel.orginRange.length - 1) * self.columnSpacing;
    
    CGRect frame = CGRectMake(x, y, _itemSize.width, height);
    
    [_autoItemAttributes[@(attributes.indexPath.section * 10 + layoutModel.week)] enumerateObjectsUsingBlock:^(ScheduleCollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsRect(frame, obj.frame)) {
            
        }
    }];
    
    attributes.frame = frame;
}

// --------------- Supplementary ---------------

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    
    UICollectionViewLayoutAttributes *attributes = _supplementaryAttributes[elementKind][indexPath];

    if (!attributes) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        _supplementaryAttributes[elementKind][indexPath] = attributes;
    }
    
    [self _transformSupplementaryAttributes:attributes];
    
    return attributes;
}

- (void)_transformSupplementaryAttributes:(UICollectionViewLayoutAttributes *)attributes {
    NSIndexPath *indexPath = attributes.indexPath;
    NSString *elementKind = attributes.representedElementKind;
    
    // Header Element
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.item == 0) {
            CGFloat x = indexPath.section * self.collectionView.width;
            CGFloat y = self.collectionView.contentOffset.y;
            CGRect frame = CGRectMake(x, y, self.widthForLeadingSupplementaryView, self.heightForHeaderSupplementaryView);
            
            attributes.frame = frame;
            attributes.zIndex = 100;
            
            return;
        }
        CGFloat x = indexPath.section * self.collectionView.width + self.widthForLeadingSupplementaryView + (indexPath.item - 1) * (self.columnSpacing + _itemSize.width);
        CGFloat y = self.collectionView.contentOffset.y;
        
        CGRect frame = CGRectMake(x, y, _itemSize.width, self.heightForHeaderSupplementaryView);
        
        attributes.frame = frame;
        attributes.zIndex = 100;
        
        return;
    }
    
    // Leading Element
    if ([elementKind isEqualToString:UICollectionElementKindSectionLeading]) {
        CGFloat x = indexPath.section * self.collectionView.width;
        CGFloat y = self.heightForHeaderSupplementaryView + indexPath.item * (self.lineSpacing + _itemSize.height);
        
        CGRect frame = CGRectMake(x, y, self.widthForLeadingSupplementaryView, _itemSize.height);
        
        attributes.frame = frame;
        
        return;
    }
    
    // Placeholder Element
    if ([elementKind isEqualToString:UICollectionElementKindSectionPlaceholder]) {
        CGFloat x = indexPath.section * self.collectionView.width + self.widthForLeadingSupplementaryView;
        CGFloat y = self.heightForHeaderSupplementaryView;
        CGFloat width = self.collectionView.width - self.widthForLeadingSupplementaryView;
        CGFloat height = self.collectionView.height - self.heightForHeaderSupplementaryView;
        
        CGRect frame = CGRectMake(x, y, width, height);
        
        attributes.frame = frame;
        
        if (self.dataSource) {
            NSUInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
            attributes.alpha = (itemCount > 0 ? 0 : 1);
        }
        
        return ;
    }
}

#pragma mark - Others

- (void)prepareLayout {
    [self _calculateLayoutIfNeeded];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    
    NSInteger itemCount = 12;
    
    CGSize contentSize = CGSizeMake(_sections * self.collectionView.bounds.size.width, self.heightForHeaderSupplementaryView + itemCount * (_itemSize.height + self.lineSpacing));
    
    return contentSize;
}

#pragma mark - (UISubclassingHooks)

+ (Class)layoutAttributesClass {
    return ScheduleCollectionViewLayoutAttributes.class;
}

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
            
            CGRect frame = CGRectMake(x, y, attributes.size.width, attributes.size.height);
            
            attributes.frame = frame;
        }];
        
        [_supplementaryAttributes[UICollectionElementKindSectionPlaceholder] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, UICollectionViewLayoutAttributes * _Nonnull attributes, BOOL * __unused stop) {
            
            CGFloat x = indexPath.section * self.collectionView.width + self.widthForLeadingSupplementaryView;
            CGFloat y = self.collectionView.contentOffset.y + self.heightForHeaderSupplementaryView;
            
            CGRect frame = CGRectMake(x, y, attributes.size.width, attributes.size.height);
            
            attributes.frame = frame;
        }];
    }
    
    // invalidate Leading Supplementary
    if (context.invalidateLeadingSupplementaryAttributes) {
        
        [_supplementaryAttributes[UICollectionElementKindSectionLeading] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, UICollectionViewLayoutAttributes * _Nonnull attributes, BOOL * __unused stop) {
            
            CGFloat x = indexPath.section * self.collectionView.width;
            CGFloat height = (_itemSize.height + self.lineSpacing) * 12;
            
            CGRect frame = CGRectMake(x, self.heightForHeaderSupplementaryView, self.widthForLeadingSupplementaryView, height);
            
            attributes.frame = frame;
        }];
    }
    
    // invalidate All Attributes
    if (context.invalidateAllAttributes || context.invalidateDataSourceCounts) {
        
        [_itemAttributes removeAllObjects];
        [_autoItemAttributes removeAllObjects];
        
        [_supplementaryAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * __unused key, NSMutableDictionary<NSIndexPath *,UICollectionViewLayoutAttributes *> * _Nonnull obj, BOOL * __unused stop) {
            [obj removeAllObjects];
        }];
    }
    
    [super invalidateLayoutWithContext:context];
}

#pragma mark - Private API

- (void)_calculateLayoutIfNeeded {
    
    NSInteger sections = [self.collectionView.dataSource performSelector:@selector(numberOfSectionsInCollectionView:) withObject:self.collectionView]
    ? [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView]
    : [self.collectionView numberOfSections];
    
    _sections = sections;
    
    CGFloat width = (self.collectionView.bounds.size.width - self.widthForLeadingSupplementaryView) / 7 - self.columnSpacing;
    
    _itemSize = CGSizeMake(width, width / 46 * 50);
}
#pragma mark - Setter

- (void)setCallBack:(BOOL)callBack {
    _callBack = callBack;
    ScheduleCollectionViewLayoutInvalidationContext *context = [[ScheduleCollectionViewLayoutInvalidationContext alloc] init];
    context.invalidateAllAttributes = YES;
    [self invalidateLayoutWithContext:context];
}

@end
