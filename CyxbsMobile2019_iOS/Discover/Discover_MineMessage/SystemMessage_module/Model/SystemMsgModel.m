//
//  MineMessageModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/17.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SystemMsgModel.h"

@implementation SystemMsgModel

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.msgAry = NSMutableArray.array;
    }
    return self;
}

- (instancetype)initWithArray:(NSArray<NSDictionary *> *)ary {
    self = [super init];
    if (self) {
        NSMutableArray <SystemMessage *> *ma = NSMutableArray.array;
        for (NSDictionary *dic in ary) {
            SystemMessage *msg = [[SystemMessage alloc] initWithDictionary:dic];
            [ma addObject:msg];
        }
        self.msgAry = ma.copy;
    }
    return self;
}

#pragma mark - Method

- (void)requestReadForIndexSet:(NSIndexSet *)set
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure {
    NSArray <SystemMessage *> *ary = [self.msgAry objectsAtIndexes:set];
    NSMutableArray <NSString *> *idNums = NSMutableArray.array;
    for (SystemMessage *msg in ary) {
        if (msg.hadRead == NO) {
            [idNums addObject:[NSString stringWithFormat:@"%ld", msg.msgID]];
        }
        msg.hadRead = YES;
    }
    NSDictionary <NSString *, NSArray <NSString *> *> *parameter = @{@"ids" : idNums.copy};
    
    // -- 网络请求：put 已读 --
    AFHTTPSessionManager *session = HttpClient.defaultClient.httpSessionManager;
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [HttpClient.defaultClient
     requestWithPath:MineMessage_PUT_hasRead_API
     method:HttpRequestPut
     parameters:parameter
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestRemoveForIndexSet:(NSIndexSet *)set
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure {
    NSMutableArray <NSString *> *idNums = NSMutableArray.array;
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [idNums addObject:[NSString stringWithFormat:@"%ld", self.msgAry[idx].msgID]];
    }];
    NSMutableArray *ma = [NSMutableArray arrayWithArray:self.msgAry];
    [ma removeObjectsAtIndexes:set];
    self.msgAry = ma;
    
    NSDictionary <NSString *, NSArray <NSString *> *> *parameter = @{@"ids" : idNums.copy};
    
    // -- 网络请求：put 已读 --
    AFHTTPSessionManager *session = HttpClient.defaultClient.httpSessionManager;
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET", @"HEAD"]];
    
    [HttpClient.defaultClient
     requestWithPath:MineMessage_DELETE_sysMsg_API
     method:HttpRequestDelete
     parameters:parameter
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
