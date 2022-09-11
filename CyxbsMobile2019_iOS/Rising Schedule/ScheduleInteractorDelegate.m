//
//  ScheduleInteractorDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleInteractorDelegate.h"

#import "ScheduleInteractorRequest.h"

#pragma mark - ScheduleInteractorDelegate ()

@interface ScheduleInteractorDelegate ()

@end

@implementation ScheduleInteractorDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [[ScheduleModel alloc] init];
    }
    return self;
}

- (void)requestAndReloadData {
    ScheduleRequestDictionary *dic = self.parameterIfNeeded;
    if (!dic) {
        dic = @{
            ScheduleModelRequestStudent : @[UserItemTool.defaultItem.stuNum]
        };
    }
    
    [ScheduleInteractorRequest
     request:dic
     success:^(ScheduleCombineModel * _Nonnull combineModel) {
        [self.model combineModel:combineModel];
        [self.collectionView reloadData];
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setCollectionView:(UICollectionView *)view {
    _collectionView = view;
    view.delegate = self;
}

@end
