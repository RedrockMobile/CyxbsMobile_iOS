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

/// 正常视图布局
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *attributes;

/// 补充视图布局
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *> *supplementaryAttributes;

@end

#pragma mark - ScheduleCollectionViewLayout

@implementation ScheduleCollectionViewLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *result = NSMutableArray.array;
    
    
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
        
        
    }
    
    _attributes[indexPath] = attributes;
    
    return attributes;
}

@end
