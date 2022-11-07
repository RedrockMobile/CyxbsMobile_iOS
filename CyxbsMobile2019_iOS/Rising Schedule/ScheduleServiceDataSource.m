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

/// 背景图
@property (nonatomic, strong) UIView *backgroundView;

@end

#pragma mark - ScheduleServiceDataSource

@implementation ScheduleServiceDataSource

- (instancetype)initWithModel:(ScheduleModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

#pragma mark - Getter

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor =
        [UIColor Light:UIColorHexARGB(#80E8F0FC)
                  Dark:UIColorHexARGB(#40000000)];
        
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}

#pragma mark - Setter

- (void)setCollectionView:(UICollectionView *)view {
    NSParameterAssert(view);
    
    [view registerClass:ScheduleCollectionViewCell.class forCellWithReuseIdentifier:ScheduleCollectionViewCellReuseIdentifier];
    [view registerClass:ScheduleCollectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleCollectionHeaderViewReuseIdentifier];
    [view registerClass:ScheduleCollectionLeadingView.class forSupplementaryViewOfKind:UICollectionElementKindSectionLeading withReuseIdentifier:ScheduleCollectionLeadingViewReuseIdentifier];
    [view registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionPlaceholder withReuseIdentifier:UICollectionElementKindSectionPlaceholder];
    
    [view addSubview:self.backgroundView];
    
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
    if (_model.courseAry.count <= section) {
        return 0;
    }
    return _model.courseAry[section].count;  // 一周的所有课程数
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCourse *course = _model.courseAry[indexPath.section][indexPath.item];
    
    ScheduleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScheduleCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.courseTitle = course.course;
    cell.courseContent = course.classRoom;
    // 正常课程
    if (course.period.location <= 4) {
        cell.drawType = ScheduleCollectionViewCellDrawMorning;
    } else if (course.period.location <= 8) {
        cell.drawType = ScheduleCollectionViewCellDrawAfternoon;
    } else if (course.period.location <= 12) {
        cell.drawType = ScheduleCollectionViewCellDrawNight;
    }

    // 自定义的事务
    if ([course.type isEqualToString:@"事务"]) {
        cell.drawType = ScheduleCollectionViewCellDrawCustom;
    }
        
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCollectionViewLayout *layout = (ScheduleCollectionViewLayout *)collectionView.collectionViewLayout;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        ScheduleCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleCollectionHeaderViewReuseIdentifier forIndexPath:indexPath];
        
        view.widthForLeadingView = layout.widthForLeadingSupplementaryView;
        view.columnSpacing = layout.columnSpacing;
        view.dataSource = self;
        view.superCollectionView = collectionView;
        view.backgroundColor = collectionView.backgroundColor;
        
        return view;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionLeading]) {
        
        ScheduleCollectionLeadingView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionLeading withReuseIdentifier:ScheduleCollectionLeadingViewReuseIdentifier forIndexPath:indexPath];
        
        view.lineSpacing = layout.lineSpacing;
        view.superCollectionView = collectionView;
        
        return view;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionPlaceholder]) {
        
        // TODO: Empty view
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionPlaceholder withReuseIdentifier:UICollectionElementKindSectionPlaceholder forIndexPath:indexPath];
        
        
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
             compareOriginAttributes:(ScheduleCollectionViewLayoutAttributes *)compareAttributes
              conflictWithAttributes:(ScheduleCollectionViewLayoutAttributes *)conflictAttributes {
    if (!_model.sno || ![_model.sno isEqualToString:@""]) {
        return NSOrderedSame;
    }
    ScheduleCourse *compareCourse = _model.courseAry[compareAttributes.indexPath.section][compareAttributes.indexPath.item];
    ScheduleCourse *conflictCourse = _model.courseAry[conflictAttributes.indexPath.section][conflictAttributes.indexPath.item];
    
    NSComparisonResult compareResult = [_model compareResultOfCourse:compareCourse];
    NSComparisonResult conflictResult = [_model compareResultOfCourse:conflictCourse];
    
    if (compareResult == conflictResult) {
        return NSOrderedSame;
    }
    // need redraw
    if (compareResult > conflictResult) {
        
    }
    
    return NSOrderedSame;
}

#pragma mark - <ScheduleCollectionHeaderViewDataSource>

- (NSString *)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view
                             leadingTitleInSection:(NSInteger)section {
    if (section == 0) {
        return @"学期";
    }
    
    NSString *title = [NSString stringWithFormat:@"%ld月", [NSDate dateWithTimeInterval:(section - 1) * 7 * 24 * 60 * 60 sinceDate:_model.startDate].month];
    return title;
}

- (BOOL)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view
                 needSourceInSection:(NSInteger)section {
    return section ? YES : NO;
}

- (NSString *)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view
                    contentDateAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeInterval:(indexPath.section - 1) * 7 * 24 * 60 * 60 + (indexPath.item - 1) * 24 * 60 * 60 sinceDate:_model.startDate];
    NSString *title = [NSString stringWithFormat:@"%ld日", date.day];
    return title;
}

- (void)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
                      isCurrentBlock:(CGRect (^)(BOOL isCurrent))currentBlock
                         atIndexPath:(NSIndexPath *)indexPath {
    
    if (_model.nowWeek != indexPath.section) {
        currentBlock(NO);
        return;
    }
    
    NSInteger weekday = NSDate.date.weekday - 1;
    weekday = weekday ? weekday : 7;
    BOOL isCurrent = (weekday == indexPath.item);
    CGRect frame = currentBlock(isCurrent);
    
    if (isCurrent) {
        self.backgroundView.alpha = 1;
        CGFloat x = indexPath.section * view.width + frame.origin.x;
        self.backgroundView.frame = CGRectMake(x, -800, frame.size.width, 800 * 3);
        [self.backgroundView.superview sendSubviewToBack:self.backgroundView];
    }
}

@end
