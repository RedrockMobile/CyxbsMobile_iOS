//
//  Goods.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "Goods.h"
//#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>
#import "ZWTMacro.h"

@implementation Goods

///网络请求
+ (void)getDataDictWithId:(NSString *)goodsid Success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(void))failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *tokenDict = @{
//        @"stuNum": @"2020211618",
//        @"idNum": @"669725"
//    };
    NSDictionary *paramDict = @{
        @"id":goodsid
    };
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager POST:@"https://be-dev.redrock.cqupt.edu.cn/magipoke/token" parameters:tokenDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary *dic = responseObject[@"data"];
//                NSString *str = dic[@"token"];
    
    
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN]  forHTTPHeaderField:@"authorization"];
        [manager GET:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-intergral/Integral/getItemInfo" parameters:paramDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(responseObject[@"data"]);
            
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];
//    }
//    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"请求失败--%@", error);
//        }];
}
@end
