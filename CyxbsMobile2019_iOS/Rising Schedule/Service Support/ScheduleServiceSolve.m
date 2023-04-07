//
//  ScheduleServiceSolve.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceSolve.h"

#import "SchedulePolicyService.h"
#import "ScheduleNETRequest.h"
#import "ScheduleWidgetCache.h"
#import "ScheduleNeedsSupport.h"

#import "TransitioningDelegate.h"
#import "ScheduleDetailController.h"
#import "ScheduleCustomViewController.h"
#import "ScheduleEventViewController.h"
#import "ScheduleWebHppleViewController.h"

#pragma mark - ScheduleServiceSolve ()

@interface ScheduleServiceSolve () <
    UICollectionViewDelegate,
    ScheduleHeaderViewDelegate,
    UIGestureRecognizerDelegate,
    ScheduleCustomViewControllerDelegate
>

@end

#pragma mark - ScheduleServiceSolve

@implementation ScheduleServiceSolve

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
    [SchedulePolicyService.current
     requestDic:self.parameterIfNeeded
     policy:^(ScheduleCombineItem * _Nonnull item) {
        [self.model combineItem:item];
        [self.collectionView reloadData];
        if (complition) {
            complition();
        }
    }
     unPolicy:^(ScheduleIdentifier * _Nonnull unpolicyKEY) {
        
    }];
}

#pragma mark - Method

- (void)scrollToSection:(NSInteger)page {
    if (page > self.model.courseIdxPaths.count || page < 0) {
        page = 0;
    }
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0) animated:YES];
}

- (void)scrollToSectionNumber:(NSNumber *)page {
    [self scrollToSection:page.longValue];
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
    if (_headerView) {
        NSInteger page = self.collectionView.contentOffset.x / self.collectionView.width;
        self.headerView.title = [self _titleForNum:page];
        
        self.headerView.reBack = (page == self.model.showWeek);
        switch (self.onShow) {
            case ScheduleModelShowGroup:
                [self.headerView setShowMuti:NO isSingle:YES];
//                self.headerView.calenderEdit = NO;
                break;
            case ScheduleModelShowSingle:
                [self.headerView setShowMuti:YES isSingle:YES];
//                self.headerView.calenderEdit = YES;
                break;
            case ScheduleModelShowDouble:
                [self.headerView setShowMuti:YES isSingle:NO];
//                self.headerView.calenderEdit = YES;
                break;
            case ScheduleModelShowWidget:
                [self.headerView setShowMuti:YES isSingle:self.headerView.isSingle];
//                self.headerView.calenderEdit = YES;
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
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)_emptyTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded && self.onShow != ScheduleModelShowGroup) {
        ScheduleCollectionViewLayout *layout = (ScheduleCollectionViewLayout *)self.collectionView.collectionViewLayout;
        NSIndexPath *idx = [layout indexPathAtPoint:[tap locationInView:self.collectionView]];
        
        ScheduleCustomViewController *vc = [[ScheduleCustomViewController alloc] initWithAppendingInSection:idx.section week:idx.week location:idx.location];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.delegate = self;
        TransitioningDelegate *delegate = [[TransitioningDelegate alloc] init];
        delegate.transitionDurationIfNeeded = 0.3;
        vc.transitioningDelegate = delegate;
        [self.viewController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Setter

- (void)setOnShow:(ScheduleModelShowType)onShow {
    _onShow = onShow;
    [self reloadHeaderView];
}

- (void)setAwakeable:(BOOL)awakeable {
    SchedulePolicyService.current.awakeable = awakeable;
}

- (BOOL)awakeable {
    return SchedulePolicyService.current.awakeable;
}

#pragma mark - <ScheduleCustomViewControllerDelegate>

- (void)viewController:(ScheduleCustomViewController *)viewController appended:(BOOL)appended {
    [ScheduleNETRequest.current
     appendCustom:viewController.courseIfNeeded
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self _changeCustom:item];
    }
     failure:^(NSError * _Nonnull error) {
    }];
}

- (void)viewController:(ScheduleCustomViewController *)viewController edited:(BOOL)edited {
    [ScheduleNETRequest.current
     editCustom:viewController.courseIfNeeded
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self _changeCustom:item];
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)viewController:(ScheduleCustomViewController *)viewController deleted:(BOOL)deleted {
    [ScheduleNETRequest.current
     deleteCustom:viewController.courseIfNeeded
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self _changeCustom:item];
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_changeCustom:(ScheduleCombineItem *)item {
    [self.model changeCustomTo:item];
    [ScheduleShareCache.shareCache cacheItem:item];
    [ScheduleShareCache.shareCache replaceForKey:item.identifier.key];
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
    NSIndexPath *locationIdxPath = self.model.courseIdxPaths[indexPath.section][indexPath.item];
    NSArray <ScheduleDetailPartContext *> *contexts = [self.model contextsWithLocationIdxPath:locationIdxPath];
    
    TransitioningDelegate *transitionDelegate = [[TransitioningDelegate alloc] init];
    transitionDelegate.transitionDurationIfNeeded = 0.3;
    transitionDelegate.supportedTapOutsideBackWhenPresent = YES;
    ScheduleDetailController *vc = [[ScheduleDetailController alloc] initWithContexts:contexts];
    vc.delegateIfNeeded = self;
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
            ScheduleModelRequestStudent : @[self.model.sno, otherKey.sno],
            ScheduleModelRequestCustom : @[self.model.sno]
        };
        self.onShow = ScheduleModelShowDouble;
        
    } else {
        self.parameterIfNeeded = @{
            ScheduleModelRequestStudent : @[self.model.sno],
            ScheduleModelRequestCustom : @[self.model.sno]
        };
        self.onShow = ScheduleModelShowSingle;
    }
    [self reloadHeaderView];
    [self requestAndReloadData:nil];
}

- (void)scheduleHeaderViewDidTapCalender:(ScheduleHeaderView *)view {
    ScheduleWebHppleViewController *root = [[ScheduleWebHppleViewController alloc] init];
    TransitioningDelegate *transitionDelegate = [[TransitioningDelegate alloc] init];
    transitionDelegate.transitionDurationIfNeeded = 0.3;
    transitionDelegate.supportedTapOutsideBackWhenPresent = YES;
    root.transitioningDelegate = transitionDelegate;
    root.modalPresentationStyle = UIModalPresentationCustom;
    [self.viewController presentViewController:root animated:YES completion:nil];
}


#pragma mark - <UIGestureRecognizerDelegate>

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    return [touch.view isKindOfClass:UICollectionView.class];
}

@end
