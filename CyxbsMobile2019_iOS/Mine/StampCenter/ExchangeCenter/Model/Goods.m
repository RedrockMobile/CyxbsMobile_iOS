//
//  Goods.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "Goods.h"
#import <AFNetworking/AFNetworking.h>
#import "ZWTMacro.h"

@implementation Goods

///网络请求
+ (void)getDataDictWithId:(NSString *)goodsid Success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(void))failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramDict = @{
        @"id":goodsid
    };
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN]  forHTTPHeaderField:@"authorization"];
        [manager GET:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-intergral/Integral/getItemInfo" parameters:paramDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(responseObject[@"data"]);
            
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];
}
@end
