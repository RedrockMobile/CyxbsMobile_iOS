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

@interface CQUPTMapViewController () <CQUPTMapViewProtocol>

@property (nonatomic, strong) CQUPTMapPresenter *presenter;
@property (nonatomic, weak) CQUPTMapContentView *contentView;

@end

@implementation CQUPTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[CQUPTMapPresenter alloc] init];
    [self.presenter attachView:self];
    
    [self.presenter requestMapData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)dealloc
{
    [self.presenter detachView];
}


#pragma mark - Presenter 回调
- (void)mapDataRequestSuccessWithMapData:(CQUPTMapDataItem *)mapData hotPlace:(CQUPTMapHotPlaceItem *)hotPlace {
    CQUPTMapContentView *contentView = [[CQUPTMapContentView alloc] initWithFrame:self.view.bounds andMapData:mapData andHotPlaceItem:hotPlace];
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

@end
