//
//  SZHSearchDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHSearchDataModel.h"

@implementation SZHSearchDataModel
//搜索热词（非搜索框内）
- (void)getHotArayWithProgress:(void (^)(NSArray * _Nonnull))progress{
    
    [HttpTool.shareTool
     request:NewQA_GET_hotWords_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"-----热词请求成功");
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *dic = object[@"data"];
        NSArray *tmpArray = dic[@"hot_words"];
        for (NSString *hotWord in tmpArray) {
            [array addObject:hotWord];
        }
        if (progress) {
            progress(array);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"------请求失败");
        NSArray *array = @[@"红岩网校",@"校庆",@"啦啦操比赛",@"话剧表演",@"奖学金",@"建模"];
        if (progress) {
            progress(array);
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_hotWords_API method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"-----热词请求成功");
//        NSMutableArray *array = [NSMutableArray array];
//        NSDictionary *dic = responseObject[@"data"];
//        NSArray *tmpArray = dic[@"hot_words"];
//        for (NSString *hotWord in tmpArray) {
//            [array addObject:hotWord];
//        }
//        progress(array);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"------请求失败");
//        NSArray *array = @[@"红岩网校",@"校庆",@"啦啦操比赛",@"话剧表演",@"奖学金",@"建模"];;
//        progress(array);
//    }];
}

//搜索动态
- (void)getSearchDynamicWithStr:(NSString *)string Success:(void (^)(NSDictionary * _Nonnull))success Failure:(void (^)(void))failure {
    
    NSDictionary *parama = @{@"key":string ,@"page":@1 ,@"size":@6};
    
    [HttpTool.shareTool
     request:NewQA_GET_searchDynamic_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parama
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            NSLog(@"搜索帖子成功---%@",object);
            NSDictionary *dic = object;
            if (success) {
                success(dic);
            }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
            failure();
            }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_searchDynamic_API method:HttpRequestGet parameters:parama prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"搜索帖子成功---%@",responseObject);
//        NSDictionary *dic = responseObject;
//        success(dic);
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            failure();
//
//            NSString *a = @"aaaaaa"
//            "bbbbbbb";
//        }];
}

//搜索重游知识库
- (void)getSearchKnowledgeWithStr:(NSString *)string Success:(void (^)(NSDictionary * _Nonnull))success Failure:(void (^)(void))failure {
    
    NSDictionary *parama = @{@"key":string ,@"page":@1 ,@"size":@6};
    
    [HttpTool.shareTool
     request:NewQA_GET_searchKnowledge_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parama
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"搜索知识库成功---%@",object);
        NSDictionary *dic = object;
        if (success) {
            success(dic);
        }

    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_searchKnowledge_API method:HttpRequestGet parameters:parama prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"搜索知识库成功---%@",responseObject);
//        NSDictionary *dic = responseObject;
//        success(dic);
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            failure();
//        }];
}


@end
