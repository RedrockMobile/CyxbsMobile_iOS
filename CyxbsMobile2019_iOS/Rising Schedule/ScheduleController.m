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

#import "ScheduleModel.h"

@interface ScheduleController ()

/// 课表视图
@property (nonatomic, strong) UICollectionView *collectionView;

/// 课表模型
@property (nonatomic, strong) ScheduleModel *model;

@end

@implementation ScheduleController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.model = [[ScheduleModel alloc] init];
    
    self.presenter.interactoerMain =
    [ScheduleInteractorMain
     interactorWithCollectionView:self.collectionView
     scheduleModel:self.model
     request:self.presenter.firstRequetDic];
    
    ((ScheduleCollectionViewLayout *)self.collectionView.collectionViewLayout).delegate = self.presenter.interactoerMain;
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Method



#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        ScheduleCollectionViewLayout *layout = [[ScheduleCollectionViewLayout alloc] init];
        layout.widthForLeadingSupplementaryView = 30;
        layout.heightForTopSupplementaryView = 50;
        layout.heightForBreathBelowHeaderView = 10;
        layout.lineSpacing = 2;
        layout.columnSpacing = 2;
        
        CGFloat top = 64;
        if (self.isPushStyle) {
            top += STATUSBARHEIGHT;
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height - top) collectionViewLayout:layout];
        _collectionView.directionalLockEnabled = YES;
        _collectionView.pagingEnabled = YES;
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

@end
