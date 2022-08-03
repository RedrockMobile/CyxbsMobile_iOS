//
//  ClassBookFL.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ClassScheduleLayout.h"

@interface ClassScheduleLayout ()

/// item布局信息
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *attributes;

/// section个数
@property (nonatomic) NSInteger numberOfsections;

/// item分别个数
@property (nonatomic) NSMutableArray <NSNumber *> *numberOfItems;

@end

#pragma mark - ClassBookFL

@implementation ClassScheduleLayout

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfItems = NSMutableArray.array;
    }
    return self;
}

// !!!: 性能优化

- (BOOL)attributesNeedToRemake {
    NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    if (sections != self.numberOfsections) {
        return YES;
    }
    for (NSInteger section = 0; section < sections; section++) {
        NSInteger items = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        if (items != self.numberOfItems[section].longValue) {
            return YES;
        }
    }
    return NO;
}

- (void)remakeAttributes {
    self.attributes = NSMutableArray.array;
    self.numberOfItems = NSMutableArray.array;
    
    NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    self.numberOfsections = sections;
    
    for (NSInteger section = 0; section < sections; section++) {
        NSInteger items = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        [self.numberOfItems addObject:[NSNumber numberWithLong:items]];
        
        for (NSInteger item = 0; item < items; item++) {
            // 1.创建以及索取
            // 创建系统indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            // 索取left的indexPath
            NSIndexPath *leftIndexPath = [self.delegate classScheduleLayout:self sectionWeekForIndexPath:indexPath];
            // 索取range的indexPath
            NSRange range = [self.delegate classScheduleLayout:self rangeForIndexPath:indexPath];
            
            CGFloat holeItemWidth = (self.collectionView.width - self.headerWidth) / 7;
            // FIXME: 如果有中午和晚上，这个计算就得发生改变
            // 2.计算
            // 左 = 第n周 * view宽 + headerWidth + itemWidth * (星期x - 1)
            CGFloat left = leftIndexPath.section * self.collectionView.width + self.headerWidth + holeItemWidth * (leftIndexPath.item - 1);
            // 上 = (第n节 - 1) * (行间距 + size高)
            CGFloat top = (range.location - 1) * (self.lineSpacing + self.itemHeight);
            // 高 = (有n节 - 1) * 行间距 + 有n节 * size高
            CGFloat height = (range.length - 1) * self.lineSpacing + range.length * self.itemHeight;
            
            // 3.创建并纳入管理
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attribute.frame = CGRectMake(left, top, holeItemWidth - self.interitemSpacing, height);
            
            [self.attributes addObject:attribute];
        }
    }
//    [self.attributes sortedArrayUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
//        
//        
//        return NSOrderedSame;
//    }];
}

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

- (void)prepareLayout {
    [super prepareLayout];
    
    if ([self attributesNeedToRemake]) {
        [self remakeAttributes];
    }
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//
//}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.numberOfsections * self.collectionView.width, self.collectionView.height);
}

@end
