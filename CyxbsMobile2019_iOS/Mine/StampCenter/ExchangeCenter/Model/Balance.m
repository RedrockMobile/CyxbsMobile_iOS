//
//  Balance.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "Balance.h"
#import <AFNetworking/AFNetworking.h>

@implementation Balance

+ (void)getDataDictWithBalance:(NSString *)goodsid Success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(void))failure {
    [[HttpClient defaultClient] requestWithPath:Stamp_Store_Main_Page
                                         method:HttpRequestGet
                                     parameters:nil
                                 prepareExecute:nil
                                       progress:nil
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success-page");
        success(responseObject[@"data"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure-page");
        failure();
    }];
}

@end
