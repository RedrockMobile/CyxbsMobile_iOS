//
//  ClassBookFL.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ClassBookFL.h"

@interface ClassBookFL ()

/// item布局信息
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *attributes;

/// section个数
@property (nonatomic) NSInteger numberOfsections;

/// item分别个数
@property (nonatomic) NSMutableArray <NSNumber *> *numberOfItems;

@end

#pragma mark - ClassBookFL

@implementation ClassBookFL

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
    self.attributes = [[NSMutableArray alloc] init];
    
    NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    self.numberOfsections = sections;
    [self.numberOfItems removeAllObjects];
    for (NSInteger section = 0; section < sections; section++) {
        NSInteger items = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        [self.numberOfItems addObject:[NSNumber numberWithLong:items]];
        for (NSInteger item = 0; item < items; item++) {
            // 1.创建以及索取
            // 创建系统indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            // 索取left的indexPath
            NSIndexPath *leftIndexPath = [self.delegate classBookFL:self leftIndexPathForIndexPath:indexPath];
            // 索取range的indexPath
            NSIndexPath *rangeIndexPath = [self.delegate classBookFL:self rangeIndexPathForIndexPath:indexPath leftIndexPath:leftIndexPath];
            // 索取size
            CGSize littleSize = [self.delegate classBookFL:self littleSizeForLeftIndexPath:leftIndexPath rangeIndexPath:leftIndexPath];
            
            // FIXME: 如果有中午和晚上，这个计算就得发生改变
            // 2.计算
            // 左 = 第n周 * view宽 + 星期m * (|间距 + size宽)
            CGFloat left = leftIndexPath.section * self.collectionView.width + leftIndexPath.item * (self.interitemSpacing + littleSize.width);
            // 上 = 第n节 * (-间距 + size高)
            CGFloat top = rangeIndexPath.section * (self.lineSpacing + littleSize.height);
            // 宽不用算，高 = (有n节 - 1) * -间距 + 有n节 * size高
            CGFloat height = (rangeIndexPath.item - 1) * self.lineSpacing + rangeIndexPath.item * littleSize.height;
            
            // 3.创建并纳入管理
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attribute.frame = CGRectMake(left, top, littleSize.width, height);
            
            [self.attributes addObject:attribute];
        }
    }
}

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

- (void)prepareLayout {
    [super prepareLayout];
    
    if ([self attributesNeedToRemake]) {
        [self remakeAttributes];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(25 * self.collectionView.width, self.collectionView.height);
}

@end
