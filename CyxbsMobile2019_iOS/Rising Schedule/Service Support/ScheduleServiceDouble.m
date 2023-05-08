//
//  ScheduleServiceDouble.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleServiceDouble.h"
#import "ScheduleHeaderView.h"
#import "ScheduleShareCache.h"

@interface ScheduleServiceDouble () <
    ScheduleHeaderViewDelegate
>

@property (nonatomic, strong) NSMapTable <ScheduleWidgetCacheKeyName, ScheduleIdentifier *> *keyToIden;

@end

@implementation ScheduleServiceDouble

#pragma mark - Overwrite

- (instancetype)initWithModel:(ScheduleModel *)model {
    self = [super initWithModel:model];
    if (self) {
        self.keyToIden = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory | NSPointerFunctionsObjectPointerPersonality valueOptions:NSMapTableStrongMemory | NSPointerFunctionsObjectPointerPersonality];
    }
    return self;
}

- (void)setHeaderView:(ScheduleHeaderView *)headerView {
    [super setHeaderView:headerView];
    headerView.delegate = self;
}

- (NSArray<ScheduleIdentifier *> *)requestKeys {
    if (self.keyToIden.count == 0) { return nil; }
    ScheduleIdentifier *main = [self.keyToIden objectForKey:ScheduleWidgetCacheKeyMain];
    ScheduleIdentifier *custom = [self.keyToIden objectForKey:ScheduleWidgetCacheKeyCustom];
    ScheduleIdentifier *other = [self.keyToIden objectForKey:ScheduleWidgetCacheKeyOther];
    NSMutableArray <ScheduleIdentifier *> *prepare = NSMutableArray.array;
    if (main) { [prepare addObject:main]; }
    if (custom) { [prepare addObject:custom]; }
    if (other && self.beDouble) { [prepare addObject:other]; }
    return prepare;
}

#pragma mark - Method

- (void)setBeDouble:(BOOL)beDouble {
    // NOTE: 如果 Main 没有，则没必要执行
    if (![self.keyToIden objectForKey:ScheduleWidgetCacheKeyMain]) {
        self.showingType = ScheduleModelShowGroup;
        return;
    }
    // NOTE: 如果 Other 没有，则永远为单人
    if (![self.keyToIden objectForKey:ScheduleWidgetCacheKeyOther]) {
        beDouble = NO;
    }
    _beDouble = beDouble;
    if (beDouble) {
        self.showingType = ScheduleModelShowDouble;
    } else {
        self.showingType = ScheduleModelShowSingle;
    }
}

- (void)setIdentifier:(ScheduleIdentifier *)identifier withWidgetKeyName:(ScheduleWidgetCacheKeyName)key {
    [self.keyToIden setObject:identifier forKey:key];
    if (key == ScheduleWidgetCacheKeyMain) {
        self.model.sno = identifier.sno;
    }
    if (self.useMemCheck) {
        [ScheduleShareCache.shareCache diskCacheKey:identifier forKeyName:key];
        [ScheduleShareCache memoryCacheKey:identifier forKeyName:key];
    }
}

- (BOOL)setMainAndCustom:(ScheduleIdentifier *)main {
    ScheduleIdentifier *custom;
    if (self.useMemCheck) {
        if (!main) {
            main = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyMain];
        }
        custom = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyCustom];
        if (![custom.sno isEqualToString:main.sno]) { custom = nil; }
    }
    if (!main) { return NO; }
    if (!custom) {
        custom = [[ScheduleIdentifier alloc] initWithSno:main.sno type:ScheduleModelRequestCustom];
        custom.useWidget = YES;
        custom.useWebView = YES;
    }
    
    [self setIdentifier:main withWidgetKeyName:ScheduleWidgetCacheKeyMain];
    [self setIdentifier:custom withWidgetKeyName:ScheduleWidgetCacheKeyCustom];
    return YES;
}

- (BOOL)setMainAndCustom:(ScheduleIdentifier *)main andOther:(ScheduleIdentifier *)other {
    BOOL mainSuc = [self setMainAndCustom:main];
    if (self.useMemCheck) {
        if (!other) {
            other = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyOther];
        }
    }
    if (!other) { return NO; }
    
    [self setIdentifier:other withWidgetKeyName:ScheduleWidgetCacheKeyOther];
    return mainSuc && other;
}

- (void)scheduleHeaderViewDidTapDouble:(ScheduleHeaderView *)view {
    [self setBeDouble:view.isSingle];
    [self requestAndReloadData:nil];
}

@end
