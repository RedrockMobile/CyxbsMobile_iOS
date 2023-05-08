//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"
#import "ScheduleController.h"

#import "ScheduleShareCache.h"
#import "ScheduleServiceSolve.h"
#import "掌上重邮-Swift.h"

#import "ScheduleServiceDouble.h"
#import "ScheduleServiceGroup.h"

#pragma mark - SchedulePresenter ()

@interface SchedulePresenter ()

@property (nonatomic, strong) ScheduleServiceSolve *service;

@end

#pragma mark - SchedulePresenter

@implementation SchedulePresenter 

- (instancetype)init {
    return [self initWithDouble];
}

- (instancetype)initWithDouble {
    self = [super init];
    if (self) {
        self.service = [[ScheduleServiceDouble alloc] initWithModel:[[ScheduleModel alloc] init]];
    }
    return self;
}

- (instancetype)initWithGroup {
    self = [super init];
    if (self) {
        self.service = [[ScheduleServiceGroup alloc] initWithModel:[[ScheduleModel alloc] init]];
    }
    return self;
}

/* CollectionView */

- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *)collectionView withPrepareWidth:(CGFloat)width {
    [self.service setingCollectionView:collectionView withPrepareWidth:width];
}

- (UICollectionView *)collectionView {
    return self.service.collectionView;
}

/* Controller */

- (void)setController:(UIViewController *)controller {
    _service.viewController = controller;
}

- (ScheduleController *)controller {
    return (ScheduleController *)_service.viewController;
}

/* Next Request */

- (void)requestAndReloadDataWithRollback:(BOOL)rollBack {
    [self.service requestAndReloadData:^{
        if (rollBack) {
            [self.service scrollToSection:self.service.model.touchItem.nowWeek];
        }
    }];
}

/* Header View */

- (void)setHeaderView:(ScheduleHeaderView *)headerView {
    self.service.headerView = headerView;
}

- (ScheduleHeaderView *)headerView {
    return self.service.headerView;
}

@end



// MARK: ScheduleServiceDouble

@implementation SchedulePresenter (ScheduleDouble)

- (void)setWithMainKey:(ScheduleIdentifier *)main {
    if (![self.service isKindOfClass:ScheduleServiceDouble.class]) { return; }
    ScheduleServiceDouble *service = (ScheduleServiceDouble *)self.service;
    [service setMainAndCustom:main];
}

- (void)setWithMainKey:(ScheduleIdentifier *)main otherKey:(ScheduleIdentifier *)other {
    if (![self.service isKindOfClass:ScheduleServiceDouble.class]) { return; }
    ScheduleServiceDouble *service = (ScheduleServiceDouble *)self.service;
    [service setMainAndCustom:main andOther:other];
}

- (void)setAtFirstUseMem:(BOOL)mem beDouble:(BOOL)beD supportEditCustom:(BOOL)editC {
    if (![self.service isKindOfClass:ScheduleServiceDouble.class]) { return; }
    ScheduleServiceDouble *service = (ScheduleServiceDouble *)self.service;
    service.useMemCheck = mem;
    service.beDouble = beD;
    service.presentCustomEditWhenTouchEmpty = editC;
}

- (void)setAtFirst:(NSDictionary *)dic {
    BOOL mem = [[dic objectForKey:@"useMem"] boolValue];
    BOOL beD = [[dic objectForKey:@"beDouble"] boolValue];
    BOOL editC = [[dic objectForKey:@"editCustom"] boolValue];
    [self setAtFirstUseMem:mem beDouble:beD supportEditCustom:editC];
}

- (void)_widgetReload {
    if (@available(iOS 14.0, *)) {
        [WidgetKitHelper reloadAllTimelines];
    }
}

@end



// MARK: ScheduleServiceGroup

@implementation SchedulePresenter (ScheduleGroup)

- (void)setWithGroup:(ScheduleRequestDictionary *)group {
    if (![self.service isKindOfClass:ScheduleServiceGroup.class]) { return; }
    ScheduleServiceGroup *service = (ScheduleServiceGroup *)self.service;
    [service setWithFastGroup:group];
}

- (void)setWithGroupKeys:(NSArray<ScheduleIdentifier *> *)gKeys {
    if (![self.service isKindOfClass:ScheduleServiceGroup.class]) { return; }
    ScheduleServiceGroup *service = (ScheduleServiceGroup *)self.service;
    [service setWithIdentifiers:gKeys];
}

@end
