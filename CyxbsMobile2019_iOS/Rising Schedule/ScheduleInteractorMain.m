//
//  ScheduleInteractorMain.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleInteractorMain.h"

#import "ScheduleInteractorRequest.h"

#import "ScheduleCollectionViewCell.h"

#import "ScheduleCollectionHeaderView.h"

#import "ScheduleCollectionLeadingView.h"

#pragma mark - ScheduleInteractorMain ()

@interface ScheduleInteractorMain () <
    ScheduleCollectionHeaderViewDataSource
>

/// 视图
@property (nonatomic, strong) UICollectionView *collectionView;

/// 数据源
@property (nonatomic, strong) ScheduleModel *model;

@end

#pragma mark - ScheduleInteractorMain

@implementation ScheduleInteractorMain

+ (instancetype)interactorWithCollectionView:(UICollectionView *)view
                               scheduleModel:(ScheduleModel *)model
                                     request:(nonnull NSDictionary
                                              <ScheduleModelRequestType,NSArray
                                              <NSString *> *> *)dic {
    NSParameterAssert(view);
    NSParameterAssert(model);
    NSParameterAssert(dic);
    
    [view registerClass:ScheduleCollectionViewCell.class forCellWithReuseIdentifier:ScheduleCollectionViewCellReuseIdentifier];
    [view registerClass:ScheduleCollectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleCollectionHeaderViewReuseIdentifier];
    [view registerClass:ScheduleCollectionLeadingView.class forSupplementaryViewOfKind:UICollectionElementKindSectionLeading withReuseIdentifier:ScheduleCollectionLeadingViewReuseIdentifier];
    
    ScheduleInteractorMain *interactor = [[ScheduleInteractorMain alloc] init];
    
    view.delegate = interactor;
    view.dataSource = interactor;
    
    interactor.collectionView = view;
    interactor.model = model;
    
    [interactor _request:dic];
    
    return interactor;
}

#pragma mark - Method

- (void)_request:(NSDictionary
                  <ScheduleModelRequestType, NSArray
                  <NSString *> *> *)dic {
    [ScheduleInteractorRequest
     request:dic
     success:^(ScheduleCombineModel * _Nonnull combineModel) {
        [self.model combineModel:combineModel];
        [self.collectionView reloadData];
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.model.courseAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.courseAry[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCourse *course = self.model.courseAry[indexPath.section][indexPath.row];
    
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
    
    if (self.showWithDifferentStu) {
        if (![course.sno isEqualToString:UserItemTool.defaultItem.stuNum]) {
            cell.drawType = ScheduleCollectionViewCellDrawCustom;
        }
    }
    
    cell.multipleSign = NO; // TODO: Unknow how to check
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCollectionViewLayout *layout = (ScheduleCollectionViewLayout *)collectionView.collectionViewLayout;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        ScheduleCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScheduleCollectionHeaderViewReuseIdentifier forIndexPath:indexPath];
 
        view.widthForLeadingView = layout.widthForLeadingSupplementaryView;
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

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: select a course
}

#pragma mark - <ScheduleCollectionViewLayoutDelegate>

- (NSUInteger)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull ScheduleCollectionViewLayout *)layout weekForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ScheduleCourse *course = self.model.courseAry[indexPath.section][indexPath.row];
    return course.inWeek;
}

- (NSRange)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull ScheduleCollectionViewLayout *)layout rangeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ScheduleCourse *course = self.model.courseAry[indexPath.section][indexPath.row];
    return course.period;
}


#pragma mark - <ScheduleCollectionHeaderViewDataSource>

- (BOOL)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view needSourceInSection:(NSInteger)section {
    return section ? YES : NO;
}


- (nonnull NSString *)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view leadingTitleInSection:(NSInteger)section {
    if (section == 0) {
        return @"学期";
    }
    NSString *title = [NSString stringWithFormat:@"%ld月", section];
    return title;
}


- (BOOL)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view isCurrentDateAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath.item % 2;
}


- (NSString * _Nullable)scheduleCollectionHeaderView:(nonnull ScheduleCollectionHeaderView *)view contentDateAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    NSString *title = [NSString stringWithFormat:@"%ld日", indexPath.item];
    return title;
}

@end
