//
//  ScheduleDetailController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleDetailController.h"

#pragma mark - ScheduleDetailController ()

@interface ScheduleDetailController ()

/// data
@property (nonatomic, strong) NSArray<ScheduleCourse *> *couseAry;

/// collection view
@property (nonatomic, strong) UICollectionView *collectionView;

@end

#pragma mark - ScheduleDetailController

@implementation ScheduleDetailController

- (instancetype)initWithCourses:(NSArray<ScheduleCourse *> *)courses {
    self = [super init];
    if (self) {
        self.couseAry = courses;
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#2D2D2D)];
    
    
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _collectionView;
}

@end
