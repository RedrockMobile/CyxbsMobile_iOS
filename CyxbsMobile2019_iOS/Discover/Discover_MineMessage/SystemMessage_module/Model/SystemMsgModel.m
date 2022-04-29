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
        // -- 等待接口 --
        { // 测试数据
            NSArray <SystemMessage *> *ary = @[
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}],
                [[SystemMessage alloc] initWithDictionary:@{}]
            ];
            self.msgAry = [NSMutableArray arrayWithArray:ary];
        }
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
    // -- 网络请求：put 已读 --
    [HttpClient.defaultClient
     requestWithJson:@""
     method:HttpRequestPut
     parameters:@{
        @"token" : UserItem.defaultItem.token,
        @"read_ids" : idNums.copy
     }
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
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
    // -- 网络请求：delete 删除 --
    [self.msgAry removeObjectsAtIndexes:set];
    [HttpClient.defaultClient
     requestWithJson:@""
     method:HttpRequestDelete
     parameters:@{
        @"token" : UserItem.defaultItem.token,
        @"delete_ids" : idNums.copy
     }
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
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
