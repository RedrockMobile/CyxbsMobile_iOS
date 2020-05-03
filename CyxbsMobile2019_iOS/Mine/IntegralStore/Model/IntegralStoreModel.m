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

@end
