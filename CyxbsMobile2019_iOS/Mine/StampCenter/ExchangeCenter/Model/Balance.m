//
//  Balance.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "Balance.h"
#import <AFNetworking/AFNetworking.h>
#import "ZWTMacro.h"

@implementation Balance

+ (void)getDataDictWithBalance:(NSString *)goodsid Success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(void))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN]  forHTTPHeaderField:@"authorization"];
    [manager GET:MAIN_PAGE_API parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(responseObject[@"data"]);
            
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];
}

@end
