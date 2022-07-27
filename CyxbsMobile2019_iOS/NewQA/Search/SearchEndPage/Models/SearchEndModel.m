//
//  SearchEndModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SearchEndModel.h"

@implementation SearchEndModel
- (void)loadRelevantDynamicDataWithStr:(NSString *)str Page:(NSInteger)page Success:(void (^)(NSArray * _Nonnull))success Failure:(void (^)(void))failure {
    
    NSDictionary *param = @{@"key":str ,@"page":@(page) ,@"size":@6};
    
    [HttpTool.shareTool
     request:NewQA_GET_searchDynamic_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"加载动态列表数据成功");
        NSArray *ary = object[@"data"];
        if (success) {
            success(ary);
        }

    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_searchDynamic_API method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"加载动态列表数据成功");
//        NSArray *ary = responseObject[@"data"];
//        success(ary);
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            failure();
//        }];
}
@end
