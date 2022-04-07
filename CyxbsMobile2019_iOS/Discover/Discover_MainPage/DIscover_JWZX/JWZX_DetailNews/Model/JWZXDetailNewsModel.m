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

- (instancetype)initWithNewsID:(NSString *)newsID {
    self = [super init];
    if (self) {
        self.newsID = newsID;
    }
    return self;
}

- (void)requestNewsSuccess:(void (^)(void))success
                   failure:(void (^)(NSError * _Nonnull))failure {
    
    [HttpClient.defaultClient
     requestWithPath:NEWSDETAIL
     method:HttpRequestGet
     parameters:@{@"id" : self.newsID}
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        [self loadWithDictionary:responseObject[@"data"]];
        if (success) {
            success();
        }
    }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"🔴JWZX Detail News Model Error:\n%@", error);
        if (failure) {
            failure(error);
        }
    }];
}

- (void)loadWithDictionary:(NSDictionary *)dic {
    self.title = dic[@"title"];
    self.date = dic[@"date"];
    self.content = dic[@"content"];
    // 测试数据:ID = 10276请求会出现
    if (dic[@"files"]) {
        NSMutableArray <JWZXNewsAnnexModel *> *annexMA = NSMutableArray.array;
        for (NSDictionary *annexDit in dic[@"files"]) {
            JWZXNewsAnnexModel *anAnnexModel = [[JWZXNewsAnnexModel alloc] initWithDictionary:annexDit];
            [annexMA addObject:anAnnexModel];
        }
        self.annexModels = [annexMA copy];
    }
}

@end
