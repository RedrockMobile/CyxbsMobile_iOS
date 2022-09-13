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

- (void)_pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.collectionView];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath) {
                return;
            }
            
            
        } break;
            
        case UIGestureRecognizerStateChanged: {
            
        } break;
            
        default: {
            
        }
    }
}

- (void)setCollectionView:(UICollectionView *)view {
    _collectionView = view;
    view.delegate = self;
    [view.panGestureRecognizer addTarget:self action:@selector(_pan:)];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
