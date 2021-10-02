//
//  Goods.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "Goods.h"
#import <AFNetworking/AFNetworking.h>
#import "HttpClient.h"

@implementation Goods

///网络请求
+ (void)getDataDictWithId:(NSString *)goodsid Success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(void))failure {
    
    NSDictionary *paramDict = @{
        @"id":goodsid
    };
    
    [[HttpClient defaultClient] requestWithPath:Stamp_Store_Goods
                                         method:HttpRequestGet
                                     parameters:paramDict
                                 prepareExecute:nil
                                       progress:nil
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success-goods");
        success(responseObject[@"data"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure-goods");
        failure();
    }];
    
}
@end
