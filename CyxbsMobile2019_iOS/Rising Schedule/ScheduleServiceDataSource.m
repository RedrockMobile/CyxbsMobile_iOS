//
//  ScheduleServiceDataSource.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceDataSource.h"

#import "ScheduleCollectionViewCell.h"

#import "ScheduleSupplementaryCollectionViewCell.h"


#pragma mark - ScheduleServiceDataSource ()

@interface ScheduleServiceDataSource ()

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
    [view registerClass:ScheduleSupplementaryCollectionViewCell.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleSupplementaryCollectionViewCellReuseIdentifier];
    [view registerClass:ScheduleSupplementaryCollectionViewCell.class forSupplementaryViewOfKind:UICollectionElementKindSectionLeading withReuseIdentifier:ScheduleSupplementaryCollectionViewCellReuseIdentifier];
    
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
    return _model.courseAry[section].count;
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
    
    if (kind != UICollectionElementKindSectionHeader && kind != UICollectionElementKindSectionLeading) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeInterval:(indexPath.section - 1) * 7 * 24 * 60 * 60 + (indexPath.item - 1) * 24 * 60 * 60 sinceDate:_model.startDate];
    NSInteger weekday = NSDate.date.weekday - 1;
    weekday = weekday ? weekday : 7;
    
    ScheduleSupplementaryCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ScheduleSupplementaryCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = collectionView.backgroundColor;
    
    if (kind == UICollectionElementKindSectionHeader) {
        cell.isTitleOnly = (indexPath.section == 0 ? YES : indexPath.item == 0);
        
        cell.title = (indexPath.section == 0 && indexPath.item == 0 ? @"学期" : indexPath.item == 0 ? [NSString stringWithFormat:@"%ld月", date.month] : [date stringWithFormat:@"EEE" timeZone:NSTimeZone.CQ locale:NSLocale.CN]);
        
        cell.content = [NSString stringWithFormat:@"%ld日", date.day];
        
        cell.isCurrent = (indexPath.section != _model.nowWeek ? NO : indexPath.item == weekday);
        
        return cell;
    }
    
    if (kind == UICollectionElementKindSectionLeading) {
        cell.isTitleOnly = YES;
        
        cell.title = @(indexPath.item + 1).stringValue;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - <ScheduleCollectionViewLayoutDataSource>

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
                      layout:(nonnull ScheduleCollectionViewLayout *)layout
 numberOfSupplementaryOfKind:(nonnull NSString *)kind
                   inSection:(NSInteger)section {
    if (kind == UICollectionElementKindSectionHeader) {
        return 8;
    }
    
    if (kind == UICollectionElementKindSectionLeading) {
        return 12;
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(ScheduleCollectionViewLayout *)layout
      pointForCellInSection:(NSInteger)section
                    forItem:(NSInteger)item {
    
    return 34;
}

- (ScheduleCollectionViewLayoutModel *)collectionView:(UICollectionView *)collectionView
                                               layout:(ScheduleCollectionViewLayout *)layout
                        layoutModelForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCourse *course = _model.courseAry[indexPath.section][indexPath.item];
    
    ScheduleCollectionViewLayoutModel *model = [[ScheduleCollectionViewLayoutModel alloc] init];
    
    model.orginRange = course.period;
    model.week = course.inWeek;
    
    return model;
}

//- (NSComparisonResult)collectionView:(UICollectionView *)collectionView
//                              layout:(ScheduleCollectionViewLayout *)layout
//             compareOriginAttributes:(ScheduleCollectionViewLayoutAttributes *)compareAttributes
//              conflictWithAttributes:(ScheduleCollectionViewLayoutAttributes *)conflictAttributes {
//    if (!_model.sno || ![_model.sno isEqualToString:@""]) {
//        return NSOrderedSame;
//    }
//    ScheduleCourse *compareCourse = _model.courseAry[compareAttributes.indexPath.section][compareAttributes.indexPath.item];
//    ScheduleCourse *conflictCourse = _model.courseAry[conflictAttributes.indexPath.section][conflictAttributes.indexPath.item];
//
//    NSComparisonResult compareResult = [_model compareResultOfCourse:compareCourse];
//    NSComparisonResult conflictResult = [_model compareResultOfCourse:conflictCourse];
//
//    if (compareResult == conflictResult) {
//        return NSOrderedSame;
//    }
//    // need redraw
//    if (compareResult > conflictResult) {
//
//    }
//
//    return NSOrderedSame;
//}

@end
