//
//  PMPPostItem.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/11/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPPostItem.h"

// 发动态
#define PostDynamic @"magipoke-loop/post/dynamic/user"

@implementation PMPPostItem

+ (void)getDataWithPage:(NSInteger)page
                  Redid:(NSString *)redid
                success:(void (^)(NSArray * _Nonnull))success
                failure:(void (^)(void))failure{
    NSDictionary * parameters = @{
        @"redid" : redid,
        @"page" : @(page),
        @"size" : @6
    };
//    [CyxbsMobileBaseURL_1 stringByAppendingString:PostDynamic];
//    [[HttpClient defaultClient]
//     requestWithPath:[self getUserWithTailURL:PostDynamic]
//     method:HttpRequestGet
//     parameters:parameters
//     prepareExecute:nil
//     progress:nil
//     success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        NSMutableArray * tempAry = [NSMutableArray arrayWithCapacity:6];
//        for (NSDictionary * dict in responseObject[@"data"]) {
//            PMPPostItem * item = [PMPPostItem mj_objectWithKeyValues:dict];
//            item.itemMDict = [dict mutableCopy];
//            if (item) {
//                [tempAry addObject:item];
//            }
//        }
//        success([tempAry copy]);
//    }
//     failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failure();
//    }];
    [[HttpClient defaultClient]
     requestWithPath:[CyxbsMobileBaseURL_1 stringByAppendingString:PostDynamic]
     method:HttpRequestGet
     parameters:parameters
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray * tempAry = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary * dict in responseObject[@"data"]) {
            PMPPostItem * item = [PMPPostItem mj_objectWithKeyValues:dict];
            item.itemMDict = [dict mutableCopy];
            if (item) {
                [tempAry addObject:item];
            }
        }
        success([tempAry copy]);
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}

- (NSDictionary<NSString *,id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys {
    return @{
        @"nick_name" : @"nickname"
    };
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}

@end
