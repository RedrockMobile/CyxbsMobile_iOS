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
    [self.presenter performSelector:@selector(requestSchoolBusLocation) afterDelay:2];
}

- (void)schoolBusLocationRequestsFailure {
    NSLog(@"校车加载失败");
}

@end
