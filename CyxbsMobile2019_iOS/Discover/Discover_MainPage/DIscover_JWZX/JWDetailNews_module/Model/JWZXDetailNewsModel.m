//
//  JWZXDetailNewsModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXDetailNewsModel.h"

#pragma mark - JWZXDetailNewsModel

@implementation JWZXDetailNewsModel

#pragma mark - Iint

- (instancetype)initWithNewsID:(NSString *)newsID {
    self = [super init];
    if (self) {
        self.newsID = newsID;
    }
    return self;
}

#pragma mark - Method

- (void)requestNewsSuccess:(void (^)(void))success
                   failure:(void (^)(NSError * _Nonnull))failure {
    
    [HttpTool.shareTool
     request:Discover_GET_newsDetail_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{@"id" : self.newsID}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"🟢JWZX Detail News Model:\n%@", object);
        [self loadWithDictionary:object[@"data"]];
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"🔴JWZX Detail News Model Error:\n%@", error);
        if (failure) {
            failure(error);
        }
    }];
    
//    [HttpClient.defaultClient
//     requestWithPath:Discover_GET_newsDetail_API
//     method:HttpRequestGet
//     parameters:@{@"id" : self.newsID}
//     prepareExecute:nil
//     progress:nil
//     success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"🟢JWZX Detail News Model:\n%@", responseObject);
//        [self loadWithDictionary:responseObject[@"data"]];
//        if (success) {
//            success();
//        }
//    }
//      failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"🔴JWZX Detail News Model Error:\n%@", error);
//        if (failure) {
//            failure(error);
//        }
//    }];
}

- (void)loadWithDictionary:(NSDictionary *)dic {
    self.title = dic[@"title"];
    self.date = dic[@"date"];
    self.content = dic[@"content"];
    // 测试数据:ID = 10276请求会出现
    if (dic[@"files"] && ![dic[@"files"] isKindOfClass:NSNull.class]) {
        NSMutableArray <JWZXNewsAnnexModel *> *annexMA = NSMutableArray.array;
        for (NSDictionary *annexDit in dic[@"files"]) {
            JWZXNewsAnnexModel *anAnnexModel = [[JWZXNewsAnnexModel alloc] initWithDictionary:annexDit];
            [annexMA addObject:anAnnexModel];
        }
        self.annexModels = [annexMA copy];
    }
}

#pragma mark - Setter

- (void)setDate:(NSString *)date {
    NSDate *theDate = [NSDate dateWithString:date format:@"yyyy-MM-dd H:m:ss.SSS"];
    NSString *dateStr = [theDate stringFromFormatter:NSDateFormatter.defaultFormatter withDateFormat:@"yyyy-MM-dd"];
    _date = dateStr;
}

@end
