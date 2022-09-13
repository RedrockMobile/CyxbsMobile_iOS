//
//  ScheduleServiceDataSource.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceDataSource.h"

#import "ScheduleCollectionViewCell.h"

#import "ScheduleCollectionHeaderView.h"

#import "ScheduleCollectionLeadingView.h"

#pragma mark - ScheduleServiceDataSource ()

@interface ScheduleServiceDataSource () <
    ScheduleCollectionHeaderViewDataSource
>

/// 视图不同
@property (nonatomic) BOOL diff;

@end

#pragma mark - ScheduleServiceDataSource

@implementation ScheduleServiceDataSource

+ (instancetype)dataSourceServiceWithModel:(ScheduleModel *)model {
    ScheduleServiceDataSource *service = [[ScheduleServiceDataSource alloc] init];
    service->_model = model;
    return service;
}

#pragma mark - Setter

- (void)setCollectionView:(UICollectionView *)view diff:(BOOL)diff{
    NSParameterAssert(view);
    
    [view registerClass:ScheduleCollectionViewCell.class forCellWithReuseIdentifier:ScheduleCollectionViewCellReuseIdentifier];
    [view registerClass:ScheduleCollectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleCollectionHeaderViewReuseIdentifier];
    [view registerClass:ScheduleCollectionLeadingView.class forSupplementaryViewOfKind:UICollectionElementKindSectionLeading withReuseIdentifier:ScheduleCollectionLeadingViewReuseIdentifier];
    
    view.dataSource = self;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!_model) {
        return 0;
    }
    return _model.courseAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _model.courseAry[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCourse *course = _model.courseAry[indexPath.section][indexPath.item];
    
    ScheduleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScheduleCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.courseTitle = course.course;
    cell.courseContent = course.classRoom;
    
    if (course.period.location <= 4) {
        cell.drawType = ScheduleCollectionViewCellDrawMorning;
    } else if (course.period.location <= 8) {
        cell.drawType = ScheduleCollectionViewCellDrawAfternoon;
    } else if (course.period.location <= 12) {
        cell.drawType = ScheduleCollectionViewCellDrawNight;
    }
    
    if ([course.type isEqualToString:@"事务"]) {
        cell.drawType = ScheduleCollectionViewCellDrawCustom;
    }
    
    if (_diff) {
        if (![course.sno isEqualToString:UserItemTool.defaultItem.stuNum]) {
            cell.drawType = ScheduleCollectionViewCellDrawCustom;
        }
    }
    
    cell.multipleSign = NO; // TODO: Unknow how to check
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCollectionViewLayout *layout = (ScheduleCollectionViewLayout *)collectionView.collectionViewLayout;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        ScheduleCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleCollectionHeaderViewReuseIdentifier forIndexPath:indexPath];
 
        view.widthForLeadingView = layout.widthForLeadingSupplementaryView;
        view.heightForBreathBelowHeaderView = 10;
        view.columnSpacing = layout.columnSpacing;
        view.delegate = self;
        [view sizeToFit];
        
        return view;
    } else if ([kind isEqualToString:UICollectionElementKindSectionLeading]) {
        ScheduleCollectionLeadingView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionLeading withReuseIdentifier:ScheduleCollectionLeadingViewReuseIdentifier forIndexPath:indexPath];
        
        view.lineSpacing = layout.lineSpacing;
        [view sizeToFit];
        
        return view;
    }
    
    return nil;
}

#pragma mark - <ScheduleCollectionViewLayoutDelegate>

- (NSUInteger)collectionView:(nonnull UICollectionView *)collectionView
                      layout:(nonnull ScheduleCollectionViewLayout *)layout
      weekForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ScheduleCourse *course = _model.courseAry[indexPath.section][indexPath.item];
    return course.inWeek;
}

- (NSRange)collectionView:(nonnull UICollectionView *)collectionView
                   layout:(nonnull ScheduleCollectionViewLayout *)layout
  rangeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ScheduleCourse *course = _model.courseAry[indexPath.section][indexPath.item];
    return course.period;
}

- (NSComparisonResult)collectionView:(UICollectionView *)collectionView
                              layout:(ScheduleCollectionViewLayout *)layout
              compareOriginIndexPath:(NSIndexPath *)originIndexPath
               conflictWithIndexPath:(NSIndexPath *)conflictIndexPath
                   relayoutWithBlock:(void (^)(NSRange originRange, NSRange comflictRange))block {
    
    ScheduleCourse *originCourse = _model.courseAry[originIndexPath.section][originIndexPath.item];
    ScheduleCourse *conflictCourse = _model.courseAry[conflictIndexPath.section][originIndexPath.item];
    
    if (NSEqualRanges(originCourse.period, conflictCourse.period)) {
        return NSOrderedSame;
    }
    
    
    
    return NSOrderedSame;
}

#pragma mark - <ScheduleCollectionHeaderViewDataSource>

- (BOOL)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view
                 needSourceInSection:(NSInteger)section {
    return section ? YES : NO;
}

- (nonnull NSString *)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view
                             leadingTitleInSection:(NSInteger)section {
    if (section == 0) {
        return @"学期";
    }
    NSString *title = [NSString stringWithFormat:@"%ld月", section];
    return title;
}

- (BOOL)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view
            isCurrentDateAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath.item % 2;
}

- (NSString * _Nullable)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view
                              contentDateAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    NSString *title = [NSString stringWithFormat:@"%ld日", indexPath.item];
    return title;
}

@end
