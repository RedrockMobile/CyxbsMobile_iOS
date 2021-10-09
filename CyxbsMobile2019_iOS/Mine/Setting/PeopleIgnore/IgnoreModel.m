//
//  IgnoreModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/3.
//  Copyright © 2021 Redrock. All rights reserved.
//  获取屏蔽的人的数据的model

#import "IgnoreModel.h"

@implementation IgnoreModel
- (void)loadMoreData {
    NSDictionary *paramDict = @{
        @"page":@(self.page),
        @"size":@"10",
    };
    
    [self.client requestWithPath:getIgnoreUid method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataArr addObjectsFromArray:responseObject[@"data"]];
        if ([responseObject[@"data"] count] < 10) {
            [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateNoMoreDate];
        }else {
            [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateEndRefresh];
            self.page++;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateFailure];
    }];
}
@end
