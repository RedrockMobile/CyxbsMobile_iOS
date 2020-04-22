//
//  EmptyClassModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/4/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "EmptyClassModel.h"

@implementation EmptyClassModel

+ (void)RequestEmptyClassDataWithParams:(NSDictionary *)params success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpClient defaultClient] requestWithPath:EMPTYCLASSAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
