//
//  SchoolBusViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SchoolBusViewController.h"
#import "SchoolBusPresenter.h"
#import "SchoolBusProtocol.h"
#import "SchoolBusContentView.h"
#import "SchoolBusItem.h"

@interface SchoolBusViewController () <SchoolBusProtocol, SchoolBusContentViewProtocol>

@property (nonatomic, strong) SchoolBusPresenter *presenter;
@property (nonatomic, weak) SchoolBusContentView *contentView;

@property (nonatomic, assign) BOOL dismissed;

@end

@implementation SchoolBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[SchoolBusPresenter alloc] init];
    [self.presenter attachView:self];
    
    [self.presenter requestSchoolBusLocation];
    
    SchoolBusContentView *contentView = [[SchoolBusContentView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.dismissed = YES;
}

- (void)dealloc
{
    [self.presenter dettachView];
}


#pragma mark - contentView回调
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - presenter回调
- (void)schoolBusLocationRequestsSuccess:(NSArray<SchoolBusItem *> *)busArray {
    [self.contentView updateSchoolBusLocation:busArray];
    
    // 校车位置加载成功后，隔2秒再加载下一个位置。
    if (!self.dismissed) {
        [self.presenter performSelector:@selector(requestSchoolBusLocation) afterDelay:2];
    }
    
    // 绘制折线
//    CLLocationCoordinate2D commonPolylineCoords[busArray.count];
//    for (int i = 0; i < busArray.count; i++) {
//        commonPolylineCoords[i].latitude = busArray[i].lat;
//        commonPolylineCoords[i].longitude = busArray[i].lon;
//    }
}

- (void)schoolBusLocationRequestsFailure {
    self.contentView.statusLabel.text = @"校车失联了";
}

@end
