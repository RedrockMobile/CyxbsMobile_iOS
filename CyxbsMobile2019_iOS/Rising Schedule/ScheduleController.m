//
//  ScheduleController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleController.h"

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
    
}

#pragma mark - Method



#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        ScheduleCollectionViewLayout *layout = [[ScheduleCollectionViewLayout alloc] init];
        layout.widthForLeadingSupplementaryView = 30;
        layout.heightForTopSupplementaryView = 40;
        layout.lineSpacing = 2;
        layout.columnSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.directionalLockEnabled = YES;
        
    }
    return _collectionView;
}

@end
