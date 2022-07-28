//
//  HotSearchModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "HotSearchModel.h"

@implementation HotSearchModel

MJCodingImplementation

- (void)getHotSearchArray {
    
    [HttpTool.shareTool
     request:NewQA_GET_hotWord_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        self.hotWordsArray = [NSMutableArray array];
        NSDictionary *dic = object[@"data"];
        NSArray *tmpArray = dic[@"hot_words"];
        for (NSString *hotWord in tmpArray) {
            [self.hotWordsArray addObject:hotWord];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HotWordsDataLoadSuccess" object:nil];

    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HotWordsDataLoadError" object:nil];
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_hotWord_API method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        self.hotWordsArray = [NSMutableArray array];
//        NSDictionary *dic = responseObject[@"data"];
//        NSArray *tmpArray = dic[@"hot_words"];
//        for (NSString *hotWord in tmpArray) {
//            [self.hotWordsArray addObject:hotWord];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"HotWordsDataLoadSuccess" object:nil];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"HotWordsDataLoadError" object:nil];
//    }];
}

@end
