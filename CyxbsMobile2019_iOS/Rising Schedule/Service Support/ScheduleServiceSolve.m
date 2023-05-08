//
//  ScheduleServiceSolve.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceSolve.h"

#import "ScheduleHeaderView.h"
#import "ScheduleNETRequest.h"
#import "ScheduleNeedsSupport.h"

#import "TransitioningDelegate.h"
#import "ScheduleDetailController.h"
#import "ScheduleCustomViewController.h"
#import "ScheduleEventViewController.h"

#pragma mark - ScheduleServiceSolve ()

@interface ScheduleServiceSolve () <
    UICollectionViewDelegate,
    ScheduleHeaderViewDelegate,
    UIGestureRecognizerDelegate,
    ScheduleCustomViewControllerDelegate,
    ScheduleRequestDelegate
>

@end

#pragma mark - ScheduleServiceSolve

@implementation ScheduleServiceSolve

#pragma mark - Over Method

- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *)view withPrepareWidth:(CGFloat)width {
    [super setingCollectionView:view withPrepareWidth:width];
    _collectionView = (*view);
    (*view).delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_emptyTap:)];
    tap.delegate = self;
    [*view addGestureRecognizer:tap];
}

#pragma mark - Use Able

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

#pragma mark - Method

- (void)setShowingType:(ScheduleModelShowType)onShow {
    _showingType = onShow;
    if (_headerView) {
        switch (onShow) {
            case ScheduleModelShowGroup:
                [self.headerView setShowMuti:NO isSingle:YES];
                break;
            case ScheduleModelShowSingle:
                [self.headerView setShowMuti:YES isSingle:YES];
                break;
            case ScheduleModelShowDouble:
                [self.headerView setShowMuti:YES isSingle:NO];
                break;
        }
        self.headerView.calenderEdit = (self.showingType != ScheduleModelShowGroup);
    }
}

- (NSArray<ScheduleIdentifier *> *)requestKeys {
    return nil;
}

- (void)requestAndReloadData:(void (^)(void))complition {
    NSArray *requestAry = self.requestKeys;
    if (!requestAry || requestAry.count == 0) { return; }
    
    [self.model clear];
    [ScheduleNETRequest.current
     policyKeys:requestAry
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self.model combineItem:item];
        [self.collectionView reloadData];
        [self reloadHeaderView];
        if (complition) { complition(); }
    }
     failure:^(NSError * _Nonnull error, ScheduleIdentifier * _Nonnull errorID) {
        
    }];
}

- (void)reloadHeaderView {
    if (_headerView) {
        NSInteger page = self.collectionView.contentOffset.x / self.collectionView.width + 0.5;
        self.headerView.title = [self _titleForNum:page];
        self.headerView.reBack = (page == self.model.showWeek);
        [self setShowingType:_showingType];
    }
}

- (void)scrollToSection:(NSInteger)page {
    if (page > self.model.courseIdxPaths.count || page < 0) {
        page = 0;
    }
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0) animated:YES];
}

- (void)scrollToSectionNumber:(NSNumber *)page {
    [self scrollToSection:page.longValue];
}

- (BOOL)useMemBeforeRequestWithKey:(ScheduleIdentifier *)key {
    return YES;
}

// MARK: private

- (NSString *)_titleForNum:(NSInteger)num {
    if (num <= 0) {
        return @"整学期";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = CNLocale();
    formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    
    return [NSString stringWithFormat:@"第%@周", [formatter stringFromNumber:@(num)]];
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
    if (tap.state == UIGestureRecognizerStateEnded && self.showingType != ScheduleModelShowGroup) {
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

#pragma mark - <ScheduleCustomViewControllerDelegate>

- (void)viewController:(ScheduleCustomViewController *)viewController appended:(BOOL)appended {
    [ScheduleNETRequest.current
     appendCustom:viewController.courseIfNeeded
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self _changeCustom:item];
    }];
}

- (void)viewController:(ScheduleCustomViewController *)viewController edited:(BOOL)edited {
    [ScheduleNETRequest.current
     editCustom:viewController.courseIfNeeded
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self _changeCustom:item];
    }];
}

- (void)viewController:(ScheduleCustomViewController *)viewController deleted:(BOOL)deleted {
    [ScheduleNETRequest.current
     deleteCustom:viewController.courseIfNeeded
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self _changeCustom:item];
    }];
}

- (void)_changeCustom:(ScheduleCombineItem *)item {
    [self.model changeCustomTo:item];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self reloadHeaderView];
}

#pragma mark - <ScheduleHeaderViewDelegate>

- (void)scheduleHeaderView:(ScheduleHeaderView *)view didSelectedBtn:(UIButton *)btn {
    [self scrollToSection:self.model.showWeek];
}

- (void)scheduleHeaderViewDidTapInfo:(ScheduleHeaderView *)view {
    return;
    // 暂时没想好怎么写
    ScheduleEventViewController *vc = [[ScheduleEventViewController alloc] init];
    UIViewController *root = [[UINavigationController alloc] initWithRootViewController:vc];
    TransitioningDelegate *transitionDelegate = [[TransitioningDelegate alloc] init];
    transitionDelegate.transitionDurationIfNeeded = 0.3;
    transitionDelegate.supportedTapOutsideBackWhenPresent = NO;
    root.transitioningDelegate = transitionDelegate;
    root.modalPresentationStyle = UIModalPresentationCustom;
    [self.viewController presentViewController:root animated:YES completion:nil];
}

#pragma mark - <ScheduleRequestDelegate>

- (BOOL)request:(ScheduleNETRequest *)request useMemEmptyItemWithDiskKey:(ScheduleIdentifier *)key {
    return [self useMemBeforeRequestWithKey:key];
}

#pragma mark - <UIGestureRecognizerDelegate>

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    return [touch.view isKindOfClass:UICollectionView.class];
}

@end
