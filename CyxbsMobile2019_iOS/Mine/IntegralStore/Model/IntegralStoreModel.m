//
//  IntegralStoreModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreModel.h"
#import "IntegralStoreDataItem.h"

@implementation IntegralStoreModel


- (void)loadStoreDataSucceeded:(void (^)(NSDictionary * _Nonnull))succeeded failed:(nonnull void (^)(void))failed {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum]
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:INTEGRALSTORELISTAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            succeeded(responseObject[@"data"]);
        } else {
            failed();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        failed();
    }];
}

- (void)buyWithName:(NSString *)name
           andValue:(NSString *)value
          Succeeded:(nonnull void (^)(void))succeeded
             failed:(nonnull void (^)(void))failed {
    
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum],
        @"name": name,
        @"value": value
    };
    
    [[HttpClient defaultClient] requestWithPath:INTEGRALSTOREORDER method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed();
    }];
}

- (void)refreshIntegralSucceeded:(void (^)(void))succeeded failed:(void (^)(void))failed {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum]
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:CHECKININFOAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [UserItemTool defaultItem].checkInDay = responseObject[@"data"][@"check_in_days"];
        [UserItemTool defaultItem].integral = responseObject[@"data"][@"integral"];
        [UserItemTool defaultItem].rank = responseObject[@"data"][@"rank"];
        [UserItemTool defaultItem].rank_Persent = responseObject[@"data"][@"percent"];
        [UserItemTool defaultItem].week_info = responseObject[@"data"][@"week_info"];
        
        succeeded();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed();
    }];
}

@end
