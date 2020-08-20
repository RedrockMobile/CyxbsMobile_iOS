//
//  CQUPTMapViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapViewController.h"
#import "CQUPTMapPresenter.h"
#import "CQUPTMapViewProtocol.h"
#import "CQUPTMapDataItem.h"
#import "CQUPTMapHotPlaceItem.h"


@interface CQUPTMapViewController () <CQUPTMapViewProtocol, CQUPTMapContentViewDelegate>

@property (nonatomic, weak) MBProgressHUD *hud;
@property (nonatomic, strong) CQUPTMapPresenter *presenter;

@end

@implementation CQUPTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"地图加载中，请耐心等待哦～";
    self.hud = hud;
    
    self.presenter = [[CQUPTMapPresenter alloc] init];
    [self.presenter attachView:self];
    
    [self.presenter requestMapData];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"Map_backgroundColor"];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter detachView];
}


#pragma mark - Presenter 回调
- (void)mapDataRequestSuccessWithMapData:(CQUPTMapDataItem *)mapData hotPlace:(nonnull NSArray<CQUPTMapHotPlaceItem *> *)hotPlaceArray {
    [self.hud hide:YES];
    
    [mapData archiveItem];
    
    CQUPTMapContentView *contentView = [[CQUPTMapContentView alloc] initWithFrame:self.view.bounds andMapData:mapData andHotPlaceItemArray:hotPlaceArray];
    contentView.backgroundColor = [UIColor colorWithHexString:mapData.mapColor];
    contentView.delegate = self;

    NSURL *mapURL = [NSURL URLWithString:mapData.mapURL];
    [contentView.mapView sd_setImageWithURL:mapURL placeholderImage:[UIImage imageNamed:@"Map_map"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        contentView.mapView.contentMode = UIViewContentModeScaleAspectFill;
    }];
    
    contentView.alpha = 0;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        contentView.alpha = 1;
    } completion:nil];
}

- (void)starPlaceRequestSuccessWithStarPlace:(CQUPTMapStarPlaceItem *)starPlace {
    [self.contentView starPlaceListRequestSuccess:starPlace];
}

- (void)searchPlaceSuccess:(NSArray<CQUPTMapSearchItem *> *)placeIDArray {
    [self.contentView searchPlaceSuccess:placeIDArray];
}

- (void)placeDetailDataRequestSuccess:(CQUPTMapPlaceDetailItem *)placeDetailItem {
    [self.contentView placeDetailDataRequestSuccess:placeDetailItem];
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
    
    if (![history containsObject:string]) {
        [history insertObject:string atIndex:0];
    }
    
    [UserDefaultTool saveValue:history forKey:CQUPTMAPHISTORYKEY];
    
    [self.presenter searchPlaceWithString:string];
}

- (void)requestPlaceDataWithPlaceID:(NSString *)placeID {
    [self.presenter requestPlaceDataWithPlaceID:placeID];
}

- (void)vrButtonTapped {
    NSLog(@"VRMap");
}

@end
