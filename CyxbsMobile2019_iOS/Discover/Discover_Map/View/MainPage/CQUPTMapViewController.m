//
//  CQUPTMapViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapViewController.h"
#import "CQUPTMapContentView.h"
#import "CQUPTMapPresenter.h"
#import "CQUPTMapViewProtocol.h"
#import <IQKeyboardManager.h>

@interface CQUPTMapViewController () <CQUPTMapViewProtocol, CQUPTMapContentViewDelegate>

@property (nonatomic, strong) CQUPTMapPresenter *presenter;
@property (nonatomic, weak) CQUPTMapContentView *contentView;

@end

@implementation CQUPTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"取消";
    
    self.presenter = [[CQUPTMapPresenter alloc] init];
    [self.presenter attachView:self];
    
    [self.presenter requestMapData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter detachView];    
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
}


#pragma mark - Presenter 回调
- (void)mapDataRequestSuccessWithMapData:(CQUPTMapDataItem *)mapData hotPlace:(nonnull NSArray<CQUPTMapHotPlaceItem *> *)hotPlaceArray {
    
    CQUPTMapContentView *contentView = [[CQUPTMapContentView alloc] initWithFrame:self.view.bounds andMapData:mapData andHotPlaceItemArray:hotPlaceArray];
    contentView.delegate = self;
    
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)starPlaceRequestSuccessWithStarArray:(NSArray<CQUPTMapStarPlaceItem *> *)starPlaceArray {
    [self.contentView starPlaceListRequestSuccess:starPlaceArray];
}

- (void)searchPlaceSuccess:(NSArray<CQUPTMapSearchItem *> *)placeIDArray {
    [self.contentView searchPlaceSuccess:placeIDArray];
}


#pragma mark - ContentView代理
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestStarData {
    [self.presenter requestStarData];
}

- (void)searchPlaceWithString:(NSString *)string {
    NSMutableArray *history = [[UserDefaultTool valueWithKey:CQUPTMAPHISTORYKEY] mutableCopy];
    if (!history) {
        history = [NSMutableArray array];
    }
    
    [history addObject:string];
    
    NSSet *set = [NSSet setWithArray:history];
    history = [[set allObjects] mutableCopy];
    
    [UserDefaultTool saveValue:history forKey:CQUPTMAPHISTORYKEY];
    
    [self.presenter searchPlaceWithString:string];
}

@end
