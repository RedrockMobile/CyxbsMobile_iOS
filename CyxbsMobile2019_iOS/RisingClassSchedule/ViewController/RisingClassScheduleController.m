//
//  RisingClassScheduleController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "RisingClassScheduleController.h"

#import "ClassBookModel.h"

#import "ClassBookCollectionView.h"

#import "ClassBookFL.h"

#import "ClassBookDataSolve.h"

#pragma mark - ClassBookController ()

@interface RisingClassScheduleController ()

/// 课表数据源
@property (nonatomic, strong) ClassBookModel *classBookModel;

/// 课表视图
@property (nonatomic, strong) ClassBookCollectionView *classBookCollectionView;

/// sovle类
@property (nonatomic, strong) ClassBookDataSolve *solve;

@end

#pragma mark - ClassBookController

@implementation RisingClassScheduleController

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.classBookModel = [[ClassBookModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    
    [self solve];
    
    self.classBookModel.needSave = YES;
    self.classBookModel.needReset = YES;
    
    [self.view addSubview:self.classBookCollectionView];
    
    // >>> 如果是多人查课表和老师查课表就不能要
    [self awakeFromWCDB];
    // 网络请求
    [self request];
}

#pragma mark - Method

- (void)awakeFromWCDB {
    [self.classBookModel readFromWCDB];
    [self.classBookCollectionView reloadData];
}

- (void)request {
    [self.classBookModel
     requestWithNum:UserItemTool.defaultItem.stuNum
     success:^{
        [self.classBookCollectionView reloadData];
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"啊这");
    }];
}

- (void)request2 {
    [self.classBookModel
     requestWithTeacher:@"040107"
     success:^{
        
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Getter

- (ClassBookCollectionView *)classBookCollectionView {
    if (_classBookCollectionView == nil) {
        ClassBookFL *fl = [[ClassBookFL alloc] init];
        fl.delegate = _solve;
        fl.lineSpacing = 2;
        fl.interitemSpacing = 2;
        
        _classBookCollectionView = [[ClassBookCollectionView alloc] initWithFrame:CGRectMake(10, 20, self.view.width - 20, self.view.height - 20) collectionViewLayout:fl];
        
        [_classBookCollectionView registerClass:SchoolLessonItem.class forCellWithReuseIdentifier:SchoolLessonItemReuseIdentifier];
        _classBookCollectionView.delegate = _solve;
        _classBookCollectionView.dataSource = _solve;
    }
    return _classBookCollectionView;
}

- (ClassBookDataSolve *)solve {
    if (_solve == nil) {
        _solve = [[ClassBookDataSolve alloc] init];
        _solve.classBookModel = self.classBookModel;
        _solve.classBookCollectionView = self.classBookCollectionView;
    }
    return _solve;
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
