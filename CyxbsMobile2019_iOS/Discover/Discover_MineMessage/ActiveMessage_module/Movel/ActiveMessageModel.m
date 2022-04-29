//
//  ActiveMessageModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ActiveMessageModel.h"

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
        NSArray <ActiveMessage *> *ary = @[
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}],
            [[ActiveMessage alloc] initWithDictionary:@{}]
        ];
        self.activeMsgAry = [NSMutableArray arrayWithArray:ary];
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
    
//    [HttpClient.defaultClient.httpSessionManager setValue:[NSString stringWithFormat:@"Bearer %@", UserItem.defaultItem.token] forKey:@"authorization"];
//    [HttpClient.defaultClient.httpSessionManager
//     PUT:@""
//     parameters:ary.copy
//     headers:nil
//     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}

@end
