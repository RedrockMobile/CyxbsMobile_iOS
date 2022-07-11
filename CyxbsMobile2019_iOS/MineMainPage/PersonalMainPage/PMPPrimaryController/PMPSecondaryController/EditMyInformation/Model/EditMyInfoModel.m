//
//  EditMyInfoModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoModel.h"

// 修改信息
#define PutPersonInfo @"magipoke/person/info"

@implementation EditMyInfoModel

+ (void)uploadProfile:(UIImage *)profile success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    /*
     merge_error
     [[HttpClient defaultClient]
      PUT:[CyxbsMobileBaseURL_1 stringByAppendingString:PutPersonInfo]
      parameters:nil
      image:profile
      imageField:@"photo_src"
      prepareExecute:nil
      progress:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
         success(responseObject);
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
     */
    [[HttpClient defaultClient]
     requestWithPath:[CyxbsMobileBaseURL_1 stringByAppendingString:PutPersonInfo]
     method:HttpRequestPut
     parameters:@{@"photo_src": UIImagePNGRepresentation(profile)}
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)uploadUserInfo:(NSDictionary *)userInfo success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    /*
     merge_error
     [[HttpClient defaultClient]
      PUT:[CyxbsMobileBaseURL_1 stringByAppendingString:PutPersonInfo]
      parameters:userInfo
      image:nil
      imageField:nil
      prepareExecute:nil
      progress:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
         success(responseObject);
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
     */
    [[HttpClient defaultClient]
     requestWithPath:[CyxbsMobileBaseURL_1 stringByAppendingString:PutPersonInfo]
     method:(HttpRequestPut)
     parameters:userInfo
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}

@end
