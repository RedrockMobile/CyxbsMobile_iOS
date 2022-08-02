//
//  ClassBookDataSolve.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/13.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ClassBookDataSolve.h"

@implementation ClassBookDataSolve

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.classBookModel.hashDic.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classBookModel.hashDic.allValues[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <SchoolLesson *> *modelAry =
    self.classBookModel.hashDic.allValues[indexPath.section].allValues[indexPath.item];
    
    SchoolLesson *model = modelAry.firstObject;
    
    SchoolLessonItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolLessonItemReuseIdentifier forIndexPath:indexPath];
    
    NSUInteger locate = model.period.location;
    if (locate < 4) {
        cell.draw = ClassBookItemDrawMorning;
    } else if (locate < 8) {
        cell.draw = ClassBookItemDrawAfternoon;
    } else if (locate < 12) {
        cell.draw = ClassBookItemDrawNight;
    }
    
    BOOL isMulty = (modelAry.count != 1);
    [cell course:model.course classRoom:model.classRoom isMulty:isMulty];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

#pragma mark - <ClassBookFLDelegate>

- (NSIndexPath *)classBookFL:(ClassBookFL *)fl leftIndexPathForIndexPath:(NSIndexPath *)indexPath {
    return self.classBookModel.hashDic.allKeys[indexPath.section];
}

- (NSIndexPath *)classBookFL:(ClassBookFL *)fl rangeIndexPathForIndexPath:(nonnull NSIndexPath *)indexPath leftIndexPath:(nonnull NSIndexPath *)leftIndexPath {
    return self.classBookModel.hashDic[leftIndexPath].allKeys[indexPath.item];
}

- (CGSize)classBookFL:(ClassBookFL *)fl littleSizeForLeftIndexPath:(NSIndexPath *)leftIndexPath rangeIndexPath:(NSIndexPath *)rangeIndexPath {
    return CGSizeMake(46, 50);
}

#pragma mark - <ClassBookCollectionViewDelegate>

- (void)classBook:(ClassBookCollectionView *)view didTapEmptyItemAtWeekIndexPath:(nonnull NSIndexPath *)weekIndexPath ofRangeIndexPath:(nonnull NSIndexPath *)rangeIndexPath {
    
}

@end
