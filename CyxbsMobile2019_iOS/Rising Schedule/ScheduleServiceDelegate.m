//
//  ScheduleServiceDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceDelegate.h"

#import "ScheduleInteractorRequest.h"

#pragma mark - ScheduleServiceDelegate ()

@interface ScheduleServiceDelegate ()

/// <#description#>
@property (nonatomic) CGPoint contentPointWhenPanNeeded;

@end

@implementation ScheduleServiceDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [[ScheduleModel alloc] init];
    }
    return self;
}

- (void)requestAndReloadData {
    ScheduleRequestDictionary *dic = self.parameterIfNeeded;
//    if (!dic) {  // 默认情况
        dic = @{
            ScheduleModelRequestStudent : @[@"2021215154"]
        };
//    }
    
    // 由识别码请求课表数据    
    // 请求到的combineModel 不是最终可以一节节课取出来的model，是一个课程（里面包含了课程的所有周数）
    [ScheduleInteractorRequest
     request:dic
     success:^(ScheduleCombineModel * _Nonnull combineModel) {
        [self.model combineModel:combineModel];
        
        [self.collectionView reloadData];

        [self scrollToSection:self.model.nowWeek];

    }
     failure:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - Method

- (void)scrollToSection:(NSUInteger)page {
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0) animated:YES];
}

#pragma mark - Setter

- (void)setCollectionView:(UICollectionView *)view {
    _collectionView = view;
    
    view.delegate = self;
    [view.panGestureRecognizer addTarget:self action:@selector(_pan:)];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
