//
//  ScheduleDetailController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleDetailController.h"

#import "ScheduleDetailCollectionViewCell.h"

#pragma mark - ScheduleDetailController ()

@interface ScheduleDetailController () <
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

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
    self.view.layer.cornerRadius = 16;
    self.view.height = 252;
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#2D2D2D)];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width / 1.5) collectionViewLayout:layout];
        _collectionView.layer.cornerRadius = 16;
        _collectionView.clipsToBounds = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:ScheduleDetailCollectionViewCell.class forCellWithReuseIdentifier:ScheduleDetailCollectionViewCellReuseIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        }
    return _collectionView;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.couseAry) {
        return 0;
    }
    return self.couseAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScheduleDetailCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.course = self.couseAry[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.size;
}

@end
