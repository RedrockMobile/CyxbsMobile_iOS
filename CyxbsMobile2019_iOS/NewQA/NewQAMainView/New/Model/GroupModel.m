//
//  GroupModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "GroupModel.h"


@implementation GroupModel

MJCodingImplementation

- (void)loadMyFollowGroup {
    
    [HttpTool.shareTool
     request:NewQA_GET_QAFollowGroup_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {

        self.dataArray = [NSMutableArray array];
        NSArray *tmpArray = object[@"data"];
        for (NSDictionary *dic in tmpArray) {
            GroupItem *item = [[GroupItem alloc] initWithDic:dic];
            [self.dataArray addObject:item];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFollowGroupDataLoadSuccess" object:nil];

    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFollowGroupDataLoadError" object:nil];
    }];
    
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_QAFollowGroup_API method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        self.dataArray = [NSMutableArray array];
//        NSArray *tmpArray = responseObject[@"data"];
//        for (NSDictionary *dic in tmpArray) {
//            GroupItem *item = [[GroupItem alloc] initWithDic:dic];
//            [self.dataArray addObject:item];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFollowGroupDataLoadSuccess" object:nil];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFollowGroupDataLoadError" object:nil];
//    }];
}

@end
