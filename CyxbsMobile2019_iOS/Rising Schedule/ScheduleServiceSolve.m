//
//  ScheduleServiceSolve.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceSolve.h"

#import "ScheduleInteractorRequest.h"

#import "ScheduleDetailController.h"

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
    }
    [self.model clear];
      
    [ScheduleInteractorRequest
     request:dic
     success:^(ScheduleCombineModel * _Nonnull combineModel) {
        [self.model combineModel:combineModel];
        
        [self.collectionView reloadData];
        [self scrollToSection:self.model.nowWeek];
        
        if (self.canUseAwake) {
            [combineModel replace];
        }
    }
     failure:^(NSError * _Nonnull error) {
        if (self.canUseAwake) {
            [dic enumerateKeysAndObjectsUsingBlock:^(ScheduleModelRequestType  _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * __unused stop) {
                for (NSString *sno in obj) {
                    ScheduleCombineModel *combine = [[ScheduleCombineModel alloc] initWithSno:sno type:key];
                    [combine awake];
                    [self.model combineModel:combine];
                }
            }];
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
