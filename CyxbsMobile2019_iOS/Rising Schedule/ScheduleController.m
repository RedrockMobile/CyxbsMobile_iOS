//
//  ScheduleController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleController.h"

#import "SchedulePresenter.h"

#import "ScheduleCollectionViewLayout.h"

#import "ScheduleHeaderView.h"

@interface ScheduleController ()

/// header view
@property (nonatomic, strong) ScheduleHeaderView *headerView;

/// 课表视图
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ScheduleController

- (instancetype)initWithPresenter:(SchedulePresenter *)presenter {
    self = [super init];
    if (self) {
        _presenter = presenter;
        presenter.controller = self;
        
        [self _drawTabbar];
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#1D1D1D)];
    
    self.presenter.collectionView = self.collectionView;
    self.presenter.delegateService.headerView = self.headerView;
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // TODO: 请求数据（依据缓存）
    [self.presenter.delegateService requestAndReloadData];
}

#pragma mark - Getter

- (ScheduleHeaderView *)headerView {
    if (_headerView == nil) {
        CGFloat top = (self.isPushStyle ? StatusBarHeight() : 0);
        _headerView = [[ScheduleHeaderView alloc] initWithFrame:CGRectMake(0, top, self.view.width, 64)];
        _headerView.backgroundColor =
        [UIColor Light:UIColorHex(#FFFFFF)
                  Dark:UIColorHex(#1D1D1D)];
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat width = self.view.width;
        
        ScheduleCollectionViewLayout *layout = [[ScheduleCollectionViewLayout alloc] init];
        layout.widthForLeadingSupplementaryView = 30;
        layout.lineSpacing = 2;
        layout.columnSpacing = 2;
        layout.heightForHeaderSupplementaryView = 10 + ((width - layout.widthForLeadingSupplementaryView) / 7 - layout.columnSpacing) / 46 * 50;
        layout.dataSource = self.presenter.dataSourceService;
        
        CGFloat top = 64 + (self.isPushStyle ? StatusBarHeight() : 0);
        
        CGFloat height = self.view.height - top;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, self.view.width, height) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.height, 0);
        _collectionView.directionalLockEnabled = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor =
        [UIColor Light:UIColorHex(#FFFFFF)
                  Dark:UIColorHex(#1D1D1D)];
    }
    return _collectionView;
}

#pragma mark - Setter

- (void)setPresenter:(SchedulePresenter *)presenter {
    _presenter = presenter;
    if (_collectionView) {
        [self.collectionView reloadData];
    }
}

#pragma mark - Getter

- (void)_drawTabbar {
    UIImage *selectImg = [[[UIImage imageNamed:@"schedule"] imageByResizeToSize:CGSizeMake(20, 20) contentMode:UIViewContentModeScaleAspectFit] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unselectImg = [[[UIImage imageNamed:@"schedule.unselect"] imageByResizeToSize:CGSizeMake(20, 20) contentMode:UIViewContentModeScaleAspectFit] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"课表" image:unselectImg selectedImage:selectImg];
    [self.tabBarItem setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Regular size:10],
        NSForegroundColorAttributeName : [UIColor Light:UIColorHex(#2923D2) Dark:UIColorHex(#465FFF)]
    } forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Regular size:10],
        NSForegroundColorAttributeName : [UIColor Light:UIColorHex(#AABCD8) Dark:UIColorHex(#8C8C8C)]
    } forState:UIControlStateNormal];
}

@end
