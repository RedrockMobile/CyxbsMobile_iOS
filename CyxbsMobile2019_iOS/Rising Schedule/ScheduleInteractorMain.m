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

#pragma mark - ScheduleInteractorMain ()

@interface ScheduleInteractorMain ()

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

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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

@end
