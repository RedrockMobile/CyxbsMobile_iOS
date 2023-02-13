//
//  ScheduleServiceDataSource.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceDataSource.h"

#import "ScheduleNeedsSupport.h"

#import "ScheduleCollectionViewCell.h"
#import "ScheduleSupplementaryCollectionViewCell.h"

#pragma mark - ScheduleServiceDataSource ()

@interface ScheduleServiceDataSource ()

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
        _backgroundView.hidden = YES;
    }
    return _backgroundView;
}

#pragma mark - Setter

- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *)view withPrepareWidth:(CGFloat)width {
    
    ScheduleCollectionViewLayout *layout = [[ScheduleCollectionViewLayout alloc] init];
    layout.widthForLeadingSupplementaryView = 30;
    layout.lineSpacing = 2;
    layout.columnSpacing = 2;
    layout.heightForHeaderSupplementaryView = ((width - layout.widthForLeadingSupplementaryView) / 7 - layout.columnSpacing) / 46 * 50;
    layout.dataSource = self;
    
    *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, 0) collectionViewLayout:layout];
    
    [*view registerClass:ScheduleCollectionViewCell.class forCellWithReuseIdentifier:ScheduleCollectionViewCellReuseIdentifier];
    [*view registerClass:ScheduleSupplementaryCollectionViewCell.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleSupplementaryCollectionViewCellReuseIdentifier];
    [*view registerClass:ScheduleSupplementaryCollectionViewCell.class forSupplementaryViewOfKind:UICollectionElementKindSectionLeading withReuseIdentifier:ScheduleSupplementaryCollectionViewCellReuseIdentifier];
    
    [*view addSubview:self.backgroundView];
    
    (*view).dataSource = self;
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
    
    ScheduleSupplementaryCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ScheduleSupplementaryCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    // set
    cell.backgroundColor = collectionView.backgroundColor;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        NSDate *showDate = [NSDate dateWithTimeInterval:(indexPath.section - 1) * 7 * 24 * 60 * 60 + (indexPath.item - 1) * 24 * 60 * 60 sinceDate:_model.touchItem.startDate];
        
        NSDateComponents *component = [ScheduleCalendar() componentsInTimeZone:CQTimeZone() fromDate:showDate];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = CQTimeZone();
        formatter.locale = CNLocale();
        formatter.dateFormat = @"EEE";
        
        NSUInteger todayWeek = ScheduleWeekOfComponentsWeek([ScheduleCalendar() component:NSCalendarUnitWeekday fromDate:NSDate.date]);
        
        
        cell.isTitleOnly = (indexPath.section == 0 ? YES : // 第0周只展示标题
                            // ⬇️假期，也就是非正常显示时，则只显示标题
                            (_model.touchItem.nowWeek >= _model.courseIdxPaths.count ? YES :
                            indexPath.item == 0)); // 其他情况则则判断是不是 “月份” 所在位置
        
        cell.title = ((indexPath.section == 0 && indexPath.item == 0) ? @"学期" : // 0周 “月份” 为 “学期”
                      // ⬇️假期，也就是非正常显示时,则显示假期
                      (_model.touchItem.nowWeek >= _model.courseIdxPaths.count && indexPath.item == 0) ? @"" :
                      // ⬇️如果是0位置，则为正常的月信息
                      ((indexPath.item == 0) ? [NSString stringWithFormat:@"%ld月", component.month] :
                       [formatter stringFromDate:showDate])); // 非0位置，则从formatter读取
        
        cell.content = [NSString stringWithFormat:@"%ld日", component.day];

        cell.isCurrent = ((indexPath.section == 0 && indexPath.item == todayWeek) ? YES :
                          (indexPath.section != _model.touchItem.nowWeek ? NO :
                           indexPath.item == todayWeek));
        
        return cell;
    }
    
    if (kind == UICollectionElementKindSectionLeading) {
        cell.isTitleOnly = YES;
        
        cell.title = _model.timeline[indexPath.item].title;
        
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
        return _model.timeline.count;
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
