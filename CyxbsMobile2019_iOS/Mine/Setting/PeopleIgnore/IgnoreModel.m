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
    
    [HttpTool.shareTool request:Mine_POST_getIgnoreUid_API type:HttpToolRequestTypePost serializer:HttpToolRequestSerializerHTTP bodyParameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        [self.dataArr addObjectsFromArray:object[@"data"]];
        if ([object[@"data"] count] < 10) {
            [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateNoMoreDate];
        }else {
            [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateEndRefresh];
            self.page++;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateFailure];
    }];
}
@end
