//
//  RisingClassScheduleController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "RisingClassScheduleController.h"

#import "ClassScheduleModel.hpp"

#import "ClassBookCollectionView.h"

#import "ClassScheduleLayout.h"

#pragma mark - ClassBookController ()

@interface RisingClassScheduleController () <
    ClassScheduleLayoutDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

/// 课表数据源
@property (nonatomic, strong) ClassScheduleModel *scheduleModel;

/// 课表视图
@property (nonatomic, strong) ClassBookCollectionView *classBookCollectionView;

@end

#pragma mark - ClassBookController

@implementation RisingClassScheduleController

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scheduleModel = [[ClassScheduleModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    
    [self.view addSubview:self.classBookCollectionView];
    
    // >>> 如果是多人查课表和老师查课表就不能要
    [self awakeFromWCDB];
    // 网络请求
    [self request];
}

#pragma mark - Method

- (void)awakeFromWCDB {
//    [self.scheduleModel readFromWCDB];
    [self.classBookCollectionView reloadData];
}

- (void)request {
    [self.scheduleModel
     request:@{
        student : @[@"2021215154"]
    }
     success:^(NSProgress * _Nonnull progress) {
        [self.classBookCollectionView reloadData];
    }
     failure:^(NSError * _Nonnull error) {
        RisingLog(R_error, @"啊这");
    }];
}

#pragma mark - Getter

- (ClassBookCollectionView *)classBookCollectionView {
    if (_classBookCollectionView == nil) {
        ClassScheduleLayout *fl = [[ClassScheduleLayout alloc] init];
        fl.delegate = self;
        fl.lineSpacing = 2;
        fl.interitemSpacing = 2;
        fl.headerWidth = 45;
        fl.itemHeight = 50;
        
        
        _classBookCollectionView = [[ClassBookCollectionView alloc] initWithFrame:CGRectMake(10, 80, self.view.width - 20, self.view.height - 80) collectionViewLayout:fl];
        
        [_classBookCollectionView registerClass:SchoolLessonItem.class forCellWithReuseIdentifier:SchoolLessonItemReuseIdentifier];
        _classBookCollectionView.delegate = self;
        _classBookCollectionView.dataSource = self;
    }
    return _classBookCollectionView;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.scheduleModel.classModel.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.scheduleModel.classModel[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SchoolLessonItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolLessonItemReuseIdentifier forIndexPath:indexPath];
    
    SchoolLesson *lesson = self.scheduleModel.classModel[indexPath.section][indexPath.item];
    
    int multyCode = self.scheduleModel.fastAry[lesson.inSection][lesson.inWeek][lesson.period.location];
    
    switch ((multyCode + 1) >> 1) {
        case 1: {
            // 1.其他人
            cell.draw = ClassBookItemDrawMulty;
        } break;
            
        case 2: {
            // 2.自定义
            cell.draw = ClassBookItemDrawCustom;
        } break;
            
        case 3:
        default: {
            // 3.自己的
            if (lesson.period.location <= 4) {
                // 3.1 上午
                cell.draw = ClassBookItemDrawMorning;
            } else if (lesson.period.location <= 8) {
                // 3.2 下午
                cell.draw = ClassBookItemDrawAfternoon;
            } else {
                // 3.3 晚上
                cell.draw = ClassBookItemDrawNight;
            }
        } break;
    }
    
    [cell course:lesson.course classRoom:lesson.classRoom isMulty:!(multyCode % 2)];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

#pragma mark - <ClassScheduleLayoutDelegate>

- (NSIndexPath *)classScheduleLayout:(ClassScheduleLayout *)layout sectionWeekForIndexPath:(NSIndexPath *)indexPath {
    SchoolLesson *lesson = self.scheduleModel.classModel[indexPath.section][indexPath.item];
    return [NSIndexPath indexPathForItem:lesson.inWeek inSection:lesson.inSection];
}

- (NSRange)classScheduleLayout:(ClassScheduleLayout *)layout rangeForIndexPath:(NSIndexPath *)indexPath {
    SchoolLesson *lesson = self.scheduleModel.classModel[indexPath.section][indexPath.item];
    
    return lesson.period;
}

#pragma mark - <ClassBookCollectionViewDelegate>

- (void)classBook:(ClassBookCollectionView *)view didTapEmptyItemAtWeekIndexPath:(nonnull NSIndexPath *)weekIndexPath ofRangeIndexPath:(nonnull NSIndexPath *)rangeIndexPath {
    
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"RisingClassScheduleController"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                RisingClassScheduleController *vc = [[self alloc] init];
                response.responseController = vc;
                
                [nav pushViewController:vc animated:YES];
            } else {
                
                response.errorCode = RouterResponseWithoutNavagation;
            }
            
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数
        } break;
            
        case RouterRequestController: {
            
            RisingClassScheduleController *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}

@end
