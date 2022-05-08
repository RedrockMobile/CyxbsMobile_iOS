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
    
    [HttpTool.shareTool
     request:MineMessage_PUT_hasRead_API
     type:HttpToolRequestTypePut
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:parameter
     progress:nil
     success:^(NSURLSessionDataTask * task, id responseObject) {
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * task, NSError * error) {
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
    
    [HttpTool.shareTool
     request:MineMessage_DELETE_sysMsg_API
     type:HttpToolRequestTypeDelete
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:parameter
     progress:nil
     success:^(NSURLSessionDataTask * task, id responseObject) {
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * task, NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
