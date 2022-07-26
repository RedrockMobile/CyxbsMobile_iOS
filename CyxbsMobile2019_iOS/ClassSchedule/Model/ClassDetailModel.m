//
//  ClassDetailModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/9/7.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassDetailModel.h"

@implementation ClassDetailModel

+ (void)requestPlaceIDWithPlaceName:(NSString *)placeName success:(void (^)(NSDictionary * _Nonnull))success {
    NSDictionary *params = @{
        @"place_search": placeName
    };
    
    [[HttpClient defaultClient] requestWithPath:Discover_POST_cquptMapSearch_API method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
