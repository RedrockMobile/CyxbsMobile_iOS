//
//  ScheduleServiceSolve.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceSolve.h"

#import "SchedulePolicyService.h"
#import "ScheduleWidgetCache.h"
#import "ScheduleNeedsSupport.h"

#import "TransitioningDelegate.h"
#import "ScheduleDetailController.h"
#import "ScheduleCustomViewController.h"

#pragma mark - ScheduleServiceSolve ()

@interface ScheduleServiceSolve () <
    UICollectionViewDelegate,
    ScheduleHeaderViewDelegate,
    UIGestureRecognizerDelegate
>

@property (nonatomic, strong) SchedulePolicyService *policy;

@end

#pragma mark - ScheduleServiceSolve

@implementation ScheduleServiceSolve

- (instancetype)initWithModel:(ScheduleModel *)model {
    self = [super initWithModel:model];
    if (self) {
        _policy = [[SchedulePolicyService alloc] init];
        _policy.outRequestTime = 45 * 60 * 60;
    }
    return self;
}

#pragma mark - Method

- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *)view withPrepareWidth:(CGFloat)width {
    [super setingCollectionView:view withPrepareWidth:width];
    _collectionView = (*view);
    (*view).delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_emptyTap:)];
    tap.delegate = self;
    [*view addGestureRecognizer:tap];
}

- (void)requestAndReloadData:(void (^)(void))complition {
    [self.model clear];
    [self.policy
     requestDic:self.parameterIfNeeded
     policy:^(ScheduleCombineItem * _Nonnull item) {
        [self.model combineItem:item];
        [self.collectionView reloadData];
        if (complition) {
            complition();
        }
        
        if (self.canUseAwake) {
            [ScheduleShareCache.shareCache replaceForKey:item.identifier.key];
        }
    }
     unPolicy:^(ScheduleIdentifier * _Nonnull unpolicyKEY) {
        if (self.canUseAwake) {
            ScheduleCombineItem *item = [ScheduleShareCache.shareCache awakeForIdentifier:unpolicyKEY];
            [self.model combineItem:item];
            [self.collectionView reloadData];
//            [self scrollToSection:self.model.touchItem.nowWeek];
        }
    }];
}

#pragma mark - Method

- (void)scrollToSection:(NSInteger)page {
    if (page > self.model.showWeek || page < 0) {
        page = 0;
    }
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0) animated:YES];
}

- (NSString *)_titleForNum:(NSInteger)num {
    if (num <= 0) {
        return @"整学期";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = CNLocale();
    formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    
    return [NSString stringWithFormat:@"第%@周", [formatter stringFromNumber:@(num)]];
}

- (void)reloadHeaderView {
    if (self.headerView) {
        NSInteger page = self.collectionView.contentOffset.x / self.collectionView.width;
        self.headerView.title = [self _titleForNum:page];
        
        self.headerView.reBack = (page == self.model.showWeek);
        switch (self.onShow) {
            case ScheduleModelShowGroup:
                [self.headerView setShowMuti:NO isSingle:YES];
                break;
            case ScheduleModelShowSingle:
                [self.headerView setShowMuti:YES isSingle:YES];
                break;
            case ScheduleModelShowDouble:
                [self.headerView setShowMuti:YES isSingle:NO];
                break;
            case ScheduleModelShowWidget:
                
                break;
        }
    }
}

- (void)setHeaderView:(ScheduleHeaderView *)headerView {
    _headerView = headerView;
    _headerView.delegate = self;
    if (self.viewController.modalPresentationStyle == UIModalPresentationCustom) {
        UIView *_bar = [[UIView alloc] initWithFrame:CGRectMake(0, 9, 27, 5)];
        _bar.centerX = _headerView.width / 2;
        _bar.layer.cornerRadius = _bar.height / 2;
        _bar.backgroundColor = [UIColor Light:UIColorHex(#E2EDFB) Dark:UIColorHex(#5A5A5A)];
        [_headerView addSubview:_bar];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panDismiss:)];
        [_headerView addGestureRecognizer:pan];
    }
    
    [self reloadHeaderView];
}

- (void)_panDismiss:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        TransitioningDelegate *delegate = [[TransitioningDelegate alloc] init];
        delegate.transitionDurationIfNeeded = 0.3;
        delegate.panGestureIfNeeded = pan;
        delegate.panInsetsIfNeeded = UIEdgeInsetsMake(self.viewController.view.top, 0, self.viewController.tabBarController.tabBar.height, 0);
        self.viewController.transitioningDelegate = delegate;
        self.viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self.viewController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)_emptyTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded && self.onShow != ScheduleModelShowGroup) {
        ScheduleCustomViewController *vc = [[ScheduleCustomViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        TransitioningDelegate *delegate = [[TransitioningDelegate alloc] init];
        vc.transitioningDelegate = delegate;
        [self.viewController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Setter

- (void)setOnShow:(ScheduleModelShowType)onShow {
    _onShow = onShow;
    [self reloadHeaderView];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
    NSIndexPath *locationIdxPath = self.model.courseIdxPaths[indexPath.section][indexPath.item];
    NSArray <ScheduleCourse *> *courses = [self.model coursesWithLocationIdxPath:locationIdxPath];
    
    TransitioningDelegate *transitionDelegate = [[TransitioningDelegate alloc] init];
    transitionDelegate.transitionDurationIfNeeded = 0.3;
    transitionDelegate.supportedTapOutsideBackWhenPresent = YES;
    ScheduleDetailController *vc = [[ScheduleDetailController alloc] initWithCourses:courses];
    vc.transitioningDelegate = transitionDelegate;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadHeaderView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self reloadHeaderView];
}

#pragma mark - <ScheduleHeaderViewDelegate>

- (void)scheduleHeaderView:(ScheduleHeaderView *)view didSelectedBtn:(UIButton *)btn {
    [self scrollToSection:self.model.showWeek];
}

- (void)scheduleHeaderViewDidTapDouble:(ScheduleHeaderView *)view {
    if (view.isSingle) {
        ScheduleIdentifier *otherKey = [ScheduleWidgetCache.shareCache getKeyWithKeyName:ScheduleWidgetCacheKeyOther usingSupport:NO];
        otherKey = otherKey ? otherKey : [ScheduleWidgetCache.shareCache getKeyWithKeyName:ScheduleWidgetCacheKeyOther usingSupport:YES];
        if (otherKey == nil) {
            return;
        }
        
        self.parameterIfNeeded = @{
            ScheduleModelRequestStudent : @[self.model.sno, otherKey.sno]
        };
        
    } else {
        self.parameterIfNeeded = @{
            ScheduleModelRequestStudent : @[self.model.sno]
        };
    }
    
    [view setShowMuti:YES isSingle:!view.isSingle];
    [self requestAndReloadData:nil];
}

#pragma mark - <UIGestureRecognizerDelegate>

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    return [touch.view isKindOfClass:UICollectionView.class];
}

@end