//
//  PMPFansFollowsAndPraiseModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/31.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPFansFollowsAndPraiseModel.h"

#define GetUserCount @"magipoke-loop/user/getUserCount"

@implementation PMPFansFollowsAndPraiseModel

+ (void)getDataWithRedid:(NSString *)redid
                 success:(void (^)(PMPFansFollowsAndPraiseModel * _Nonnull))success
                 failure:(void (^)(void))failure {
    NSDictionary *parameters = @{
        @"redid" : redid
    };
    
    [HttpTool.shareTool
     request:Mine_GET_getUserCount_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        PMPFansFollowsAndPraiseModel * infoModel = [PMPFansFollowsAndPraiseModel mj_objectWithKeyValues:object[@"data"]];
        if (success) {
            success(infoModel);
        }
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
        if (failure) {
            failure();
        }
    }];
    
//    [[HttpClient defaultClient]
//     requestWithPath:[CyxbsMobileBaseURL_1 stringByAppendingString:GetUserCount]
//     method:HttpRequestGet
//     parameters:parameters
//     prepareExecute:nil
//     progress:nil
//     success:^(NSURLSessionDataTask *task, id responseObject) {
//        PMPFansFollowsAndPraiseModel * infoModel = [PMPFansFollowsAndPraiseModel mj_objectWithKeyValues:responseObject[@"data"]];
//        success(infoModel);
//    }
//     failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"failure");
//        failure();
//    }];
    
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}

@end
