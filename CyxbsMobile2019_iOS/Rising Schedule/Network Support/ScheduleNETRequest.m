//
//  ScheduleNETRequest.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleNETRequest.h"

#import "ScheduleCourse.h"

#import "HttpTool.h"
#import "ScheduleAPI.h"

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

@implementation ScheduleNETRequest

static ScheduleNETRequest *_current;
+ (ScheduleNETRequest *)current {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _current = [[ScheduleNETRequest alloc] init];
    });
    return _current;
}

#pragma mark - Method

+ (void)request:(ScheduleRequestDictionary *)requestDictionary
        success:(void (^)(ScheduleCombineItem *))success
        failure:(nonnull void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    
    for (ScheduleModelRequestType type in requestDictionary.allKeys) {
        if (type == ScheduleModelRequestCustom) {
            NSString *sno = requestDictionary[type].firstObject;
            [self.current requestCustom:sno success:success failure:failure];
            continue;
        }
        for (NSString *sno in requestDictionary[type]) {
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
    }
}

- (void)requestCustom:(NSString *)sno
              success:(void (^)(ScheduleCombineItem *))success
              failure:(nonnull void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    ScheduleIdentifier *key = [ScheduleIdentifier identifierWithSno:sno type:ScheduleModelRequestCustom];
    if (self.customItem == nil) {
        if (failure) {
            failure([NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:@{@"info": @"无事务"}], key);
            return;
        }
    }
    if (![self.customItem.value isKindOfClass:NSMutableArray.class]) {
        self.customItem = [ScheduleCombineItem combineItemWithIdentifier:key value:self.customItem.value.mutableCopy];
    }
    if (success) {
        success(self.customItem);
    }
}

- (void)appendCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *))success
             failure:(void (^)(NSError *))failure {
    if (![self.customItem.value isKindOfClass:NSMutableArray.class]) {
        self.customItem = [ScheduleCombineItem combineItemWithIdentifier:self.customItem.identifier value:self.customItem.value.mutableCopy];
    }
    NSMutableArray *ary = (NSMutableArray *)self.customItem.value;
    [ary addObject:course];
    if (success) {
        success(self.customItem);
    }
    
}

- (void)editCustom:(ScheduleCourse *)course
           success:(nonnull void (^)(ScheduleCombineItem *))success
           failure:(nonnull void (^)(NSError *))failure {
    if (success && [self.customItem.value containsObject:course]) {
        success(self.customItem);
    }
}

- (void)deleteCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *))success
             failure:(void (^)(NSError *))failure {
    if (![self.customItem.value isKindOfClass:NSMutableArray.class]) {
        self.customItem = [ScheduleCombineItem combineItemWithIdentifier:self.customItem.identifier value:self.customItem.value.mutableCopy];
    }
    NSMutableArray *ary = (NSMutableArray *)self.customItem.value;
    [ary removeObject:course];
    if (success) {
        success(self.customItem);
    }
}

@end
