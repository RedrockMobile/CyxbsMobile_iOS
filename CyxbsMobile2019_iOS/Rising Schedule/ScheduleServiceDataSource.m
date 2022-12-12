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
    return _model.courseIdxPaths.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_model.courseIdxPaths[section]) {
        return 0;
    }
    return _model.courseIdxPaths[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *locationIdxPath = _model.courseIdxPaths[indexPath.section][indexPath.item];
    ScheduleCollectionViewModel *viewModel = [_model.mapTable objectForKey:locationIdxPath];
    
    ScheduleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScheduleCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.courseTitle = viewModel.title;
    cell.courseContent = viewModel.content;
    
    switch (viewModel.kind) {
        /* FistSystem */
        case ScheduleBelongFistSystem: {
            if (locationIdxPath.location <= 4) {
                cell.drawType = ScheduleCollectionViewCellDrawMorning;
            } else if (locationIdxPath.location <= 8) {
                cell.drawType = ScheduleCollectionViewCellDrawAfternoon;
            } else if (locationIdxPath.location <= 12) {
                cell.drawType = ScheduleCollectionViewCellDrawNight;
            }
        } break;
            
        /* FistCustom */
        case ScheduleBelongFistCustom: {
            cell.drawType = ScheduleCollectionViewCellDrawCustom;
        } break;
            
        /* SecondSystem */
        case ScheduleBelongSecondSystem: {
            cell.drawType = ScheduleCollectionViewCellDrawOthers;
        } break;
    }
    
    // muti
    cell.isMuti = viewModel.hadMuti;
    
    cell.oneLenth = (viewModel.lenth == 1) ;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (kind != UICollectionElementKindSectionHeader && kind != UICollectionElementKindSectionLeading) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeInterval:(indexPath.section - 1) * 7 * 24 * 60 * 60 + (indexPath.item - 1) * 24 * 60 * 60 sinceDate:_model.startDate];
    
    NSUInteger currentDayWeek = date.weekday;
    currentDayWeek = (currentDayWeek + 6) % 7 + currentDayWeek / 7;
    
    ScheduleSupplementaryCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ScheduleSupplementaryCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    // set
    cell.backgroundColor = collectionView.backgroundColor;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        NSUInteger aboveWeek = NSDate.date.weekday + 6;
        NSUInteger todayWeek = aboveWeek % 8 + aboveWeek / 7;
        
        cell.isTitleOnly = (indexPath.section == 0 ? YES : indexPath.item == 0);
        
        cell.title = ((indexPath.section == 0 && indexPath.item == 0) ? @"学期" :
                      ((indexPath.item == 0) ? [NSString stringWithFormat:@"%ld月", date.month] :
                       [date stringWithFormat:@"EEE" timeZone:NSTimeZone.CQ locale:NSLocale.CN]));
        
        cell.content = [NSString stringWithFormat:@"%ld日", date.day];
        
        cell.isCurrent = (indexPath.section == 0 ? NO :
                          (indexPath.section != _model.nowWeek ? NO :
                           indexPath.item == todayWeek));
        
        return cell;
    }
    
    if (kind == UICollectionElementKindSectionLeading) {
        cell.isTitleOnly = YES;
        
        cell.title = @(indexPath.item + 1).stringValue;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - ScheduleCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfSupplementaryOfKind:(NSString *)kind inSection:(NSInteger)section {
    if (kind == UICollectionElementKindSectionHeader) {
        return 8;
    }
    if (kind == UICollectionElementKindSectionLeading) {
        return 12;
    }
    return 0;
}

#pragma mark - <ScheduleCollectionViewLayoutDataSource>

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView
                         layout:(ScheduleCollectionViewLayout *)layout
            locationAtIndexPath:(NSIndexPath *)indexPath {
    return _model.courseIdxPaths[indexPath.section][indexPath.item];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(ScheduleCollectionViewLayout *)layout
  lenthForLocationIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewModel *vm = [_model.mapTable objectForKey:indexPath];
    return vm.lenth;
}

@end
