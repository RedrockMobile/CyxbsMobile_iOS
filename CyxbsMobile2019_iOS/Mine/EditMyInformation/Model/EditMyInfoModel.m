//
//  EditMyInfoModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoModel.h"

@implementation EditMyInfoModel

+ (void)uploadProfile:(UIImage *)profile success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum]
    };
    
    [[HttpClient defaultClient] uploadImageWithJson:UPLOADPROFILEAPI method:HttpRequestPost parameters:params imageArray:@[profile] imageNames:@[@"fold"] prepareExecute:nil progress:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)uploadUserInfo:(NSDictionary *)userInfo success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpClient defaultClient] requestWithPath:UPLOADUSERINFOAPI method:HttpRequestPost parameters:userInfo prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
