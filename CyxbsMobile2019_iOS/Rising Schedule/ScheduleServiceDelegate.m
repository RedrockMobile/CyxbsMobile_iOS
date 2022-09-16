//
//  ScheduleServiceDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceDelegate.h"

#import "ScheduleInteractorRequest.h"

#import "ScheduleCollectionViewLayout.h"

#pragma mark - ScheduleServiceDelegate ()

@interface ScheduleServiceDelegate ()

/// <#description#>
@property (nonatomic) CGPoint contentPointWhenPanNeeded;

/// <#description#>
@property (nonatomic, strong) UIView *currentBackgroundView;

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
        
        [self setCurrentIndexPath:[NSIndexPath indexPathForItem:NSDate.today.weekday - 1 inSection:self.model.nowWeek]];
        [self scrollToSection:self.model.nowWeek];
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

#pragma mark - Method

- (void)setCurrentIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCollectionViewLayout *layout = (ScheduleCollectionViewLayout *)self.collectionView.collectionViewLayout;
    CGFloat width = (self.collectionView.width - layout.widthForLeadingSupplementaryView) / 7 - layout.columnSpacing;
    
    self.currentBackgroundView.alpha = 1;
    self.currentBackgroundView.left = indexPath.section * self.collectionView.width + layout.widthForLeadingSupplementaryView + (indexPath.item - 1) * (width + layout.columnSpacing);
}

- (void)scrollToSection:(NSUInteger)page {
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0) animated:YES];
}

#pragma mark - Getter

- (UIView *)currentBackgroundView {
    if (_currentBackgroundView == nil) {
        ScheduleCollectionViewLayout *layout = (ScheduleCollectionViewLayout *)self.collectionView.collectionViewLayout;
        
        CGFloat width = (self.collectionView.width - layout.widthForLeadingSupplementaryView) / 7 - layout.columnSpacing;
        
        _currentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(-1, -200, width, 2 * self.collectionView.height * 3)];
        _currentBackgroundView.backgroundColor =
        [UIColor dm_colorWithLightColor:UIColorHex(#E8F0FC80)
                              darkColor:UIColorHex(#00000040)];
        
        _currentBackgroundView.alpha = 0;
        _currentBackgroundView.layer.zPosition = -1;
    }
    return _currentBackgroundView;
}

#pragma mark - Setter

- (void)setCollectionView:(UICollectionView *)view {
    _collectionView = view;
    
    view.delegate = self;
    [view.panGestureRecognizer addTarget:self action:@selector(_pan:)];
    [view addSubview:self.currentBackgroundView];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
