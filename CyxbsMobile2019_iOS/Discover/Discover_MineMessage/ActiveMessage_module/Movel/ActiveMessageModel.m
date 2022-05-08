//
//  ActiveMessageModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ActiveMessageModel.h"

#import "HttpTool.h"

#pragma mark - ActiveMessageModel

@implementation ActiveMessageModel

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.activeMsgAry = NSMutableArray.array;
    }
    return self;
}

- (instancetype)initWithArray:(NSArray <NSDictionary *> *)ary {
    self = [super init];
    if (self) {
        NSMutableArray <ActiveMessage *> *ma = NSMutableArray.array;
        for (NSDictionary *dic in ary) {
            ActiveMessage *msg = [[ActiveMessage alloc] initWithDictionary:dic];
            [ma addObject:msg];
        }
        self.activeMsgAry = ma.copy;
    }
    return self;
}

# pragma mark - Method

- (void)requestReadForIndexSet:(NSIndexSet *)set
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure {
    NSArray <ActiveMessage *> *ary = [self.activeMsgAry objectsAtIndexes:set];
    NSMutableArray <NSString *> *idnums = NSMutableArray.array;
    for (ActiveMessage *msg in ary) {
        if (!msg.hadRead) {
            [idnums addObject:[NSString stringWithFormat:@"%ld", msg.msgID]];
        }
        msg.hadRead = YES;
    }
    NSDictionary <NSString *, NSArray <NSString *> *> *parameter = @{@"ids" : idnums.copy};
    
    // -- 网络请求：put 已读 --
    [HttpTool.shareTool
     request:MineMessage_PUT_hasRead_API
     type:HttpToolRequestTypePut
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:parameter
     progress:nil
     success:^(NSURLSessionDataTask * tast, id respon) {
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
