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
    {
        self.systemMsgModel = [[SystemMsgModel alloc] initWithArray:@[]];
        self.activeMsgModel = [[ActiveMessageModel alloc] initWithArray:@[]];
        success();
    }
}

@end
