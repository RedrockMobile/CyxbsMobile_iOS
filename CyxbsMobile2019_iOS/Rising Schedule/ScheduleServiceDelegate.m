//
//  ScheduleServiceDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceDelegate.h"

#import "ScheduleInteractorRequest.h"

#import "ScheduleDetailController.h"

#import "UIViewController+KNSemiModal.h"

#pragma mark - ScheduleServiceDelegate ()

@interface ScheduleServiceDelegate () <
    UICollectionViewDelegate,
    ScheduleHeaderViewDelegate
>

/// unKnow
@property (nonatomic) CGPoint contentPointWhenPanNeeded __deprecated_msg("还没用");

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
    if (!dic) {  // 默认情况
        dic = @{
            ScheduleModelRequestStudent : @[@"2021215154"]
        };
    }
    
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
    self.headerView.title = [self _titleForNum:page];
    self.headerView.reBack = (page != self.model.nowWeek);
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

#pragma mark - Setter

- (void)setCollectionView:(UICollectionView *)view {
    _collectionView = view;
    view.delegate = self;
}

- (void)setHeaderView:(ScheduleHeaderView *)headerView {
    _headerView = headerView;
    _headerView.delegate = self;
    [self reloadHeaderView];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCourse *selectCourse = self.model.courseAry[indexPath.section][indexPath.item];
    NSArray <ScheduleCourse *> *courses = [self.model coursesWithCourse:selectCourse inWeek:indexPath.section];
    
    ScheduleDetailController *vc = [[ScheduleDetailController alloc] initWithCourses:courses];
    [self.viewController presentSemiViewController:vc withOptions:@{
        KNSemiModalOptionKeys.pushParentBack : @(NO),
        KNSemiModalOptionKeys.parentAlpha : @(1),
        KNSemiModalOptionKeys.animationDuration : @(0.3),
        KNSemiModalOptionKeys.shadowOpacity : @(0.2)
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadHeaderView];
}

#pragma mark - <ScheduleHeaderViewDelegate>

- (void)scheduleHeaderView:(ScheduleHeaderView *)view didSelectedBtn:(UIButton *)btn {
    [self scrollToSection:self.model.nowWeek];
}

@end
