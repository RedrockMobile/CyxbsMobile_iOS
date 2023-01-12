//
//  ScheduleNETRequest.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleNETRequest.h"

#import "ScheduleWidgetCache.h"
#import "ScheduleCourse.h"

#import "HttpTool.h"
#import "NetURL.h"
#import "ScheduleAPI.h"

static NSString *urlForRequest(ScheduleModelRequestType type) {
    if (type == ScheduleModelRequestStudent) {
        return STRS(NetURL.base.bedev, scheule.stu);
    }
    if (type == ScheduleModelRequestCustom) {
        return STRS(NetURL.base.bedev, scheule.transaction.get);
    }
    if (type == ScheduleModelRequestTeacher) {
        return STRS(NetURL.base.bedev, scheule.tea);
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

@implementation ScheduleNETRequest

#pragma mark - Method

+ (void)request:(ScheduleRequestDictionary *)requestDictionary
        success:(void (^)(ScheduleCombineItem *))success
        failure:(nonnull void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    
    for (ScheduleModelRequestType type in requestDictionary.allKeys) {
        for (NSString *sno in requestDictionary[type]) {
            [HttpTool.shareTool
             request:urlForRequest(type)
             type:HttpToolRequestTypePost
             serializer:HttpToolRequestSerializerHTTP
             bodyParameters:@{
                keyForType(type) : sno,
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
                
                [ScheduleShareCache.shareCache cacheItem:item];
                if ([item.identifier isEqual:ScheduleWidgetCache.shareCache.nonatomicMainID]) {
                    ScheduleWidgetCache.shareCache.nonatomicMainID = item.identifier;
                    ScheduleWidgetCache.shareCache.mainID = item.identifier;
                } else if ([item.identifier isEqual:ScheduleWidgetCache.shareCache.nonatomicOtherID]) {
                    ScheduleWidgetCache.shareCache.nonatomicOtherID = item.identifier;
                    ScheduleWidgetCache.shareCache.otherID = item.identifier;
                }
               
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
    }
}

+ (void)appendCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *))success
             failure:(void (^)(NSError *))failure {
    
}

+ (void)editCustom:(ScheduleCourse *)course
           success:(nonnull void (^)(ScheduleCombineItem *))success
           failure:(nonnull void (^)(NSError *))failure {
    
}

+ (void)deleteCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *))success
             failure:(void (^)(NSError *))failure {
    
}

@end
