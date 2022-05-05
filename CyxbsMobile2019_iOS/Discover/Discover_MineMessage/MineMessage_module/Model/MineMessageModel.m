//
//  MineMessageModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "MineMessageModel.h"

#pragma mark - MineMessageModel

@implementation MineMessageModel

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.systemMsgModel = [[SystemMsgModel alloc] init];
        self.activeMsgModel = [[ActiveMessageModel alloc] init];
    }
    return self;
}

- (void)requestSuccess:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    [HttpClient.defaultClient
     requestWithPath:MineMessage_GET_allMsg_API
     method:HttpRequestGet
     parameters:nil
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"🟢%@:\n%@", self.class, responseObject);
        NSDictionary *data = responseObject[@"data"];
        self.systemMsgModel = [[SystemMsgModel alloc] initWithArray:data[@"system_msg"]];
        self.activeMsgModel = [[ActiveMessageModel alloc] initWithArray:data[@"active_msg"]];
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"🔴%@:\n%@", self.class, error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
