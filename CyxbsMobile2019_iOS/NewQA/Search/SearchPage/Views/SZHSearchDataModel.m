//
//  SZHSearchDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHSearchDataModel.h"

@implementation SZHSearchDataModel
- (void)getHotArayWithProgress:(void (^)(NSArray * _Nonnull))progress{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/search/getSearchHotWord" method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"-----热词请求成功");
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *dic = responseObject[@"data"];
        NSArray *tmpArray = dic[@"hot_words"];
        for (NSString *hotWord in tmpArray) {
            [array addObject:hotWord];
        }
        progress(array);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"------请求失败");
        NSArray *array = @[@"红岩网校",@"校庆",@"啦啦操比赛",@"话剧表演",@"奖学金",@"建模"];;
        progress(array);
    }];
}

- (void)getSearchDynamicWithStr:(NSString *)string Sucess:(void (^)(NSDictionary * _Nonnull))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parama = @{@"key":string ,@"page":@1 ,@"size":@6};
    [client requestWithPath:NEWQA_SEARCH_DYNAMIC_API method:HttpRequestGet parameters:parama prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"搜索帖子成功---%@",responseObject);
        NSDictionary *dic = responseObject;
        sucess(dic);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure();
        }];
}

- (void)getSearchKnowledgeWithStr:(NSString *)string Sucess:(void (^)(NSDictionary * _Nonnull))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parama = @{@"key":string ,@"page":@1 ,@"size":@6};
    [client requestWithPath:NEWQA_SEARCH_KNOWLEDGE_API method:HttpRequestGet parameters:parama prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"搜索知识库成功---%@",responseObject);
        NSDictionary *dic = responseObject;
        sucess(dic);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure();
        }];
}


@end
