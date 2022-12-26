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

#import "UIViewController+KNSemiModal.h"

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
    if (!dic) {
        [self.collectionView reloadData];
        return;
    }
    [self.model clear];
    
    NSMutableDictionary *finDic = NSMutableDictionary.dictionary;
    NSArray <ScheduleIdentifier *> *ids = ScheduleIdentifiersFromScheduleRequestDictionary(dic);
    for (ScheduleIdentifier *identifier in ids) {
        ScheduleCombineItem *item = [ScheduleShareCache.shareCache getItemForKey:identifier.key];
        if (item) {
            [self.model combineItem:item];
            [self.collectionView reloadData];
        } else {
            [finDic objectForKey:identifier.type] ?: [finDic setObject:NSMutableArray.array forKey:identifier.type];
            [finDic[identifier.type] addObject:identifier.sno];
        }
    }
    
    if (!finDic.count) {
        return;
    }
    
    [ScheduleNETRequest
     request:finDic
     success:^(ScheduleCombineItem * _Nonnull item) {
        [self.model combineItem:item];
        [self.collectionView reloadData];
        [self scrollToSection:self.model.nowWeek];
        
        [ScheduleShareCache.shareCache cacheItem:item];
        
        if (self.canUseAwake) {
            [ScheduleShareCache.shareCache replaceForKey:item.identifier.key];
        }
    }
     failure:^(NSError * _Nonnull error) {
        if (self.canUseAwake) {
            NSArray <ScheduleIdentifier *> *ids = ScheduleIdentifiersFromScheduleRequestDictionary(finDic);
            for (ScheduleIdentifier *identifier in ids) {
                ScheduleCombineItem *item = [ScheduleShareCache.shareCache awakeForIdentifier:identifier];
                [self.model combineItem:item];
            }
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
    formatter.locale = NSLocale.CN;
    formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    
    return [NSString stringWithFormat:@"第%@周", [formatter stringFromNumber:@(num)]];
}

- (void)reloadHeaderView {
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.width;
    self.headerView.title = [self _titleForNum:page];
    self.headerView.reBack = (page != self.model.nowWeek);
}

- (void)setHeaderView:(ScheduleHeaderView *)headerView {
    _headerView = headerView;
    _headerView.delegate = self;
    [self reloadHeaderView];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *locationIdxPath = self.model.courseIdxPaths[indexPath.section][indexPath.item];
    NSArray <ScheduleCourse *> *courses = [self.model coursesWithLocationIdxPath:locationIdxPath];
    
    ScheduleDetailController *vc = [[ScheduleDetailController alloc] initWithCourses:courses];
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
    [self.viewController presentSemiViewController:vc withOptions:@{
        KNSemiModalOptionKeys.pushParentBack : @(NO),
        KNSemiModalOptionKeys.parentAlpha : @(1),
        KNSemiModalOptionKeys.animationDuration : @(0.3),
        KNSemiModalOptionKeys.shadowOpacity : @(0.2)
    }];
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
