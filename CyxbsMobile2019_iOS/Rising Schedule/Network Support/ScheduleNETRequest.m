//
//  ScheduleNETRequest.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleNETRequest.h"
#import "ScheduleCombineItemSupport.h"
#import "ScheduleCourse.h"

#import "ScheduleShareCache.h"
#import "HttpTool.h"
#import "ScheduleAPI.h"

#pragma mark - static C method

static NSString *urlForRequest(ScheduleModelRequestType type) {
    if (type == ScheduleModelRequestStudent) {
        return @"https://be-prod.redrock.cqupt.edu.cn/magipoke-jwzx/kebiao";
    }
    if (type == ScheduleModelRequestCustom) {
        return @"https://be-prod.redrock.cqupt.edu.cn/magipoke-jwzx/kebiao";
    }
    if (type == ScheduleModelRequestTeacher) {
        return @"https://be-prod.redrock.cqupt.edu.cn/magipoke-jwzx/kebiao";
    }
    return @"";
}

static NSString *keyForType(ScheduleModelRequestType type) {
    if (type == ScheduleModelRequestStudent ||
        type == ScheduleModelRequestCustom) {
        return @"stu_num";
    }
    if (type == ScheduleModelRequestTeacher) {
        return @"tea";
    }
    return @"";
}

#pragma mark - ScheduleNETRequest

@implementation ScheduleNETRequest

// current available

static ScheduleNETRequest *_current;
+ (ScheduleNETRequest *)current {
    if (_current == nil) {
        _current = [[ScheduleNETRequest alloc] init];
        _current.outRequestTime = 45 * 60 * 60;
    }
    return _current;
}

+ (void)setCurrent:(ScheduleNETRequest *)current {
    _current = current;
}

@end


#pragma mark - ScheduleNETRequest (Network)

@implementation ScheduleNETRequest (Network)

+ (void)requestDic:(ScheduleRequestDictionary *)requestDictionary
           success:(void (^)(ScheduleCombineItem * _Nonnull))success
           failure:(void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    for (ScheduleModelRequestType type in requestDictionary) {
        for (NSString *sno in requestDictionary[type]) {
            [self _urlSno:sno type:type success:success failure:failure];
        }
    }
}

+ (void)requestKeys:(NSArray<ScheduleIdentifier *> *)keys
            success:(void (^)(ScheduleCombineItem * _Nonnull))success
            failure:(void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    for (ScheduleIdentifier *key in keys) {
        if (key.type == ScheduleModelRequestCustom) {
            [self.current policyCustom:key success:success];
            continue;
        }
        [self _urlSno:key.sno type:key.type success:success failure:failure];
    }
}

+ (void)_urlSno:(NSString *)sno
           type:(ScheduleModelRequestType)type
        success:(void (^)(ScheduleCombineItem * _Nonnull))success
        failure:(void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    
    if (type == ScheduleModelRequestCustom) {
        return [self.current policyCustom:[ScheduleIdentifier identifierWithSno:sno type:type] success:success];
    }
    
    [HttpTool.shareTool
     request:urlForRequest(type)
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{
        @"stu_num" : sno
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable object) {
        
        NSArray *lessonAry = [object objectForKey:@"data"];
        
        BOOL check = (!object || !lessonAry || lessonAry.count == 0);
        if (check) {
            NSAssert(check, @"\n🔴%s data : %@", __func__, lessonAry);
            return;
        }
        
        NSString *sno = object[@"stuNum"];
        NSInteger nowWeek = [object[@"nowWeek"] longValue];
        
        ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:sno type:type];
        [identifier setExpWithNowWeek:nowWeek];
        
        NSMutableArray *ary = NSMutableArray.array;
        for (NSDictionary *courceDictionary in lessonAry) {
            ScheduleCourse *course = [[ScheduleCourse alloc] initWithDictionary:courceDictionary];
            [ary addObject:course];
        }
        
        ScheduleCombineItem *item = [ScheduleCombineItem combineItemWithIdentifier:identifier value:ary];
       
        if (success) {
            success(item);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:sno type:type];
        if (failure) {
            failure(error, identifier);
        }
    }];
}

@end



#pragma mark - ScheduleNETRequest (Policy)

@implementation ScheduleNETRequest (Policy)

- (void)policyKeys:(NSArray<ScheduleIdentifier *> *)keys
           success:(void (^)(ScheduleCombineItem * _Nonnull))success
           failure:(void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    for (ScheduleIdentifier *key in keys) {
        __block ScheduleIdentifier *dickKey = [key moveFrom:[ScheduleShareCache.shareCache diskKeyForKey:key.key forKeyName:nil]];
        __block ScheduleCombineItem *diskItem = [ScheduleShareCache.shareCache diskItemForKey:dickKey forKeyName:nil];
        if (!diskItem && dickKey.useWebView) {
            diskItem = [ScheduleShareCache memoryItemForKey:dickKey.key forKeyName:nil];
        }
        NSTimeInterval now = NSDate.date.timeIntervalSince1970;
        if (dickKey.iat <= now || dickKey.iat - now >= self.outRequestTime) {
            [self.class requestKeys:@[dickKey] success:^(ScheduleCombineItem * _Nonnull item) {
                dickKey = [dickKey moveFrom:item.identifier];
                if (dickKey.useWebView) {
                    [ScheduleShareCache memoryCacheItem:item forKeyName:nil];
                }
                item = [ScheduleCombineItem combineItemWithIdentifier:dickKey value:item.value];
                if (success) { success(item); }
            } failure:^(NSError * _Nonnull error, ScheduleIdentifier * _Nonnull errorID) {
                if (diskItem && success) { success(diskItem); }
            }];
        } else {
            if (success) { success(diskItem); }
        }
    }
}

- (ScheduleCombineItem *)customItem {
    if (_customItem == nil) {
        ScheduleCombineItem *mitem = [ScheduleShareCache memoryItemForKey:nil forKeyName:ScheduleWidgetCacheKeyCustom];
        _customItem = [ScheduleCombineItem combineItemWithIdentifier:[mitem.identifier moveFrom:[ScheduleShareCache.shareCache diskKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyCustom]] value:mitem.value.mutableCopy];
    }
    return _customItem;
}

- (void)policyCustom:(ScheduleIdentifier *)cKey
             success:(void (^)(ScheduleCombineItem * _Nonnull))success {
    ScheduleIdentifier *newKey = [cKey moveFrom:self.customItem.identifier];
    newKey = [cKey moveFrom:[ScheduleShareCache.shareCache diskKeyForKey:cKey.sno forKeyName:cKey.type]];
    newKey.useWebView = YES;
    [ScheduleShareCache.shareCache diskCacheKey:newKey forKeyName:ScheduleWidgetCacheKeyCustom];
    NSMutableArray *ary = [self.customItem.value isKindOfClass:NSMutableArray.class] ? self.customItem.value : self.customItem.value.mutableCopy;
    ScheduleCombineItem *combine = [ScheduleCombineItem combineItemWithIdentifier:newKey value:ary];
    _customItem = combine;
    if (success) { success(self.customItem); }
}

- (void)appendCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *item))success {
    if (![self.customItem.value isKindOfClass:NSMutableArray.class]) {
        self.customItem = [ScheduleCombineItem combineItemWithIdentifier:self.customItem.identifier value:self.customItem.value.mutableCopy];
    }
    NSMutableArray *ary = (NSMutableArray *)self.customItem.value;
    [ary addObject:course];
    [ScheduleShareCache memoryCacheItem:self.customItem forKeyName:ScheduleWidgetCacheKeyCustom];
    if (success) { success(self.customItem); }
}

- (void)editCustom:(ScheduleCourse *)course
           success:(void (^)(ScheduleCombineItem *item))success {
    if ([self.customItem.value containsObject:course]) {
        [ScheduleShareCache memoryCacheItem:self.customItem forKeyName:ScheduleWidgetCacheKeyCustom];
        if (success) { success(self.customItem); }
    }
}

- (void)deleteCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *item))success {
    if (![self.customItem.value isKindOfClass:NSMutableArray.class]) {
        self.customItem = [ScheduleCombineItem combineItemWithIdentifier:self.customItem.identifier value:self.customItem.value.mutableCopy];
    }
    NSMutableArray *ary = (NSMutableArray *)self.customItem.value;
    [ary removeObject:course];
    [ScheduleShareCache memoryCacheItem:self.customItem forKeyName:ScheduleWidgetCacheKeyCustom];
    if (success) { success(self.customItem); }
}

@end
