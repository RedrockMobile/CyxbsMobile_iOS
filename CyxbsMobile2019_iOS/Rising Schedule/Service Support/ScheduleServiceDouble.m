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
    ScheduleIdentifier *main = [self.keyToIden objectForKey:ScheduleWidgetCacheKeyMain];
    ScheduleIdentifier *custom = [self.keyToIden objectForKey:ScheduleWidgetCacheKeyCustom];
    if (!main) { return; }
    if (view.isSingle) {
        ScheduleIdentifier *other = [self.keyToIden objectForKey:ScheduleWidgetCacheKeyOther];
        if (!other) { return; }
    }
    
//    NSString *custom = [NSString stringWithFormat:@"%@%@", ScheduleModelRequestCustom, self.firstKey.sno];
//    ScheduleIdentifier *customKey = [ScheduleShareCache memoryKeyForKey:custom forKeyName:ScheduleWidgetCacheKeyCustom];
//    if (view.isSingle) {
//        ScheduleIdentifier *otherKey = [ScheduleShareCache.shareCache diskKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyOther];
//        otherKey = otherKey ? otherKey : [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyOther];
//        if (otherKey == nil) { return; }
//        _requestKeys = @[self.firstKey, customKey, otherKey].mutableCopy;
//        self.showingType = ScheduleModelShowDouble;
//    } else {
//        _requestKeys = @[self.firstKey, customKey].mutableCopy;
//        self.showingType = ScheduleModelShowSingle;
//    }
    [self reloadHeaderView];
    [self requestAndReloadData:nil];
}

@end
