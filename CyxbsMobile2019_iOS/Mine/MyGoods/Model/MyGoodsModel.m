//
//  MyGoodsModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyGoodsModel.h"

@implementation MyGoodsModel

+ (void)requestMyGoodsWithParams:(NSDictionary *)params
                         success:(void (^)(NSDictionary * _Nonnull))success
                         failure:(void (^)(NSError * _Nonnull))failure {
    
    [[HttpClient defaultClient] requestWithPath:MYGOODSLISTAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
