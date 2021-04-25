//
//  NewCountModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewCountModel.h"

@implementation NewCountModel

- (void)queryNewCountWithTimestamp:(NSString *)timestamp {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"last":timestamp};
    [client requestWithPath:NEW_QA_QUERYNEWCOUNT method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_PostCountArray = [NSArray arrayWithArray:responseObject[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-NewPostQuerySuccessful" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)firstQueryWithTimestamp:(NSString *)timestamp {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"last":timestamp};
    [client requestWithPath:NEW_QA_QUERYNEWCOUNT method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_PostCountArray = [NSArray arrayWithArray:responseObject[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-FirstPostQuerySuccessful" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

@end
