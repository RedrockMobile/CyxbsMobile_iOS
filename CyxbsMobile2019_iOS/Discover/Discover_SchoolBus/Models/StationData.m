//
//  StationData.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2022/5/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "StationData.h"


@implementation StationData

+ (instancetype)LineDataWithDict:(NSDictionary *)dict {
    StationData *data = [[self alloc] init];
    data.line_id = [dict[@"id"] intValue];
    data.line_name = dict[@"name"];
    data.run_time = dict[@"run_time"];
    data.send_type = dict[@"send_type"];
    data.run_type = dict[@"run_type"];
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:99];
    for (NSDictionary *dic in dict[@"stations"]) {
        [mArray addObject:dic];
    }
    data.stations = mArray.copy;
    return data;
}
+ (instancetype)StationDataWithDict:(NSDictionary *)dict {
    StationData *data = [[self alloc] init];
    
    return data;
}
+ (void)StationWithSuccess:(void (^)(NSArray * _Nonnull array))success
                   Failure:(void (^)(NSError *error))failure {
    HttpClient *client = [HttpClient defaultClient];
    [client.httpSessionManager GET: Discover_GET_schoolStation_API parameters: nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = responseObject[@"data"][@"lines"];
        NSLog(@"qwe%@", array);
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:99];
        for (NSDictionary *dic in array) {
            StationData *data = [self LineDataWithDict: dic];
            [mArray addObject:data];
        }
        //调用成功的回调
        if (success) {
            success(mArray.copy);
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}

@end
