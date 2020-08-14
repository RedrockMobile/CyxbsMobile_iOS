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
#import "CQUPTMapDataItem.h"
#import "CQUPTMapHotPlaceItem.h"
#import <IQKeyboardManager.h>
#import "CQUPTMapPlaceDetailController.h"
#import "CQUPTMapDetailTransitionAnimator.h"
#import "CQUPTMapDetailPercentDrivenController.h"


@interface CQUPTMapViewController () <CQUPTMapViewProtocol, CQUPTMapContentViewDelegate, UIViewControllerTransitioningDelegate>

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
    [mapData archiveItem];
    
    
    CQUPTMapContentView *contentView = [[CQUPTMapContentView alloc] initWithFrame:self.view.bounds andMapData:mapData andHotPlaceItemArray:hotPlaceArray];
    contentView.backgroundColor = [UIColor colorWithHexString:mapData.mapColor];
    contentView.delegate = self;

    NSURL *mapURL = [NSURL URLWithString:mapData.mapURL];
    [contentView.mapView sd_setImageWithURL:mapURL placeholderImage:[UIImage imageNamed:@"Map_map"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        contentView.mapView.contentMode = UIViewContentModeScaleAspectFill;
    }];
    
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
    
    if (![history containsObject:string]) {
        [history insertObject:string atIndex:0];
    }
    
    [UserDefaultTool saveValue:history forKey:CQUPTMAPHISTORYKEY];
    
    [self.presenter searchPlaceWithString:string];
}

- (void)transitionViewDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.presentPanGesture = sender;
        
        CQUPTMapPlaceDetailController *vc = [[CQUPTMapPlaceDetailController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


#pragma mark - 转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[CQUPTMapDetailTransitionAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[CQUPTMapDetailTransitionAnimator alloc] init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.presentPanGesture) {
        return [[CQUPTMapDetailPercentDrivenController alloc] initWithPanGesture:self.presentPanGesture];
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.presentPanGesture) {
        return [[CQUPTMapDetailPercentDrivenController alloc] initWithPanGesture:self.presentPanGesture];
    } else {
        return nil;
    }
}


@end
