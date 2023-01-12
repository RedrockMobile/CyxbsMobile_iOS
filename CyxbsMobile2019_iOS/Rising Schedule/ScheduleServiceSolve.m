//
//  ScheduleServiceSolve.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceSolve.h"

#import "ScheduleNETRequest.h"

#import "ScheduleDetailController.h"

#import "ScheduleShareCache.h"

#import "TransitioningDelegate.h"

#pragma mark - ScheduleServiceSolve ()

@interface ScheduleServiceSolve () <
    UICollectionViewDelegate,
    ScheduleHeaderViewDelegate
>

@end

#pragma mark - ScheduleServiceSolve

@implementation ScheduleServiceSolve

- (void)setCollectionView:(UICollectionView *)view {
    [super setCollectionView:view];
    _collectionView = view;
    view.delegate = self;
}

- (void)requestAndReloadData {
    ScheduleRequestDictionary *dic = self.parameterIfNeeded;
    // if dic is empty or have nothing, return
    if (!dic || dic.count == 0) {
        [self.collectionView reloadData];
        return;
    }
    [self.model clear];
    // check if Memenry have cache item
    NSMutableArray <ScheduleIdentifier *> *unInMemIds = NSMutableArray.array;
    NSArray <ScheduleIdentifier *> *ids = ScheduleIdentifiersFromScheduleRequestDictionary(dic);
    for (ScheduleIdentifier *idsItem in ids) {
        ScheduleCombineItem *cacheItem = [ScheduleShareCache.shareCache getItemForKey:idsItem.key];
        if (cacheItem) {
            [self.model combineItem:cacheItem];
        } else {
            [unInMemIds addObject:idsItem];
        }
    }
    // if all in MEM, do nont request
    if (unInMemIds.count == 0) {
        return;
    }
    
    dic = ScheduleRequestDictionaryFromScheduleIdentifiers(unInMemIds);
    [ScheduleNETRequest
     request:dic
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self.model combineItem:item];
        [self.collectionView reloadData];
        [self scrollToSection:self.model.nowWeek];
        
        if (self.canUseAwake) {
            [ScheduleShareCache.shareCache replaceForKey:item.identifier.key];
        }
    }
     failure:^(NSError * _Nonnull error, ScheduleIdentifier *errorID) {
        if (self.canUseAwake) {
            ScheduleCombineItem *item = [ScheduleShareCache.shareCache awakeForIdentifier:errorID];
            [self.model combineItem:item];
            [self.collectionView reloadData];
            [self scrollToSection:self.model.nowWeek];
        }
    }];
}

#pragma mark - Method

- (void)scrollToSection:(NSUInteger)page {
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0) animated:YES];
}

- (NSString *)_titleForNum:(NSInteger)num {
    if (num <= 0) {
        return @"整学期";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    
    return [NSString stringWithFormat:@"第%@周", [formatter stringFromNumber:@(num)]];
}

- (void)reloadHeaderView {
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.width;
    self.headerView.title = [self _titleForNum:page];
    self.headerView.reBack = (page == self.model.nowWeek);
}

- (void)setHeaderView:(ScheduleHeaderView *)headerView {
    _headerView = headerView;
    _headerView.delegate = self;
    [self reloadHeaderView];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
    NSIndexPath *locationIdxPath = self.model.courseIdxPaths[indexPath.section][indexPath.item];
    NSArray <ScheduleCourse *> *courses = [self.model coursesWithLocationIdxPath:locationIdxPath];
    
    TransitioningDelegate *transitionDelegate = [[TransitioningDelegate alloc] init];
    transitionDelegate.transitionDurationIfNeeded = 0.3;
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
    [self scrollToSection:self.model.nowWeek];
}

- (void)scheduleHeaderViewDidTapDouble:(ScheduleHeaderView *)view {
    [view setShowMuti:view.isShow isSingle:!view.isSingle];
}

@end
