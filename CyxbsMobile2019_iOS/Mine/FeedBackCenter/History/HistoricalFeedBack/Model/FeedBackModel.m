//
//  FeedBackModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackModel.h"

@implementation FeedBackModel

+ (void)getDataArySuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(void))failure {
    NSMutableArray * mAry = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        FeedBackModel * model = [[FeedBackModel alloc] init];
        model.title = [NSString stringWithFormat:@"标题表头多好我的%d", i];
        model.date = 1628845560 + i * 100;
        model.isRead = i % 2;
        model.isReplied = i % 2;
        [mAry addObject:model];
    }
    success([mAry copy]);
}

@end
