//
//  JWZXSectionNews.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/5/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXSectionNews.h"

#pragma mark - JWZXSectionNews

@implementation JWZXSectionNews

#pragma mark - Life cycle

+ (void)requestWithPage:(NSInteger)page
                success:(void (^)(JWZXSectionNews * _Nullable))success
                failure:(void (^)(NSError * _Nonnull))failure {
    [HttpTool.shareTool
     request:Discover_GET_NewsPage_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{
        @"page" : [NSNumber numberWithLong:page]
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        JWZXSectionNews *sectionNews = [[JWZXSectionNews alloc] init];
        
        sectionNews->_page = [object[@"page"] longValue];
        NSMutableArray *newsMA = [NSMutableArray array];
        for (NSDictionary *dic in object[@"data"]) {
            JWZXNew *aNew = [[JWZXNew alloc] initWithDictionary:dic];
            [newsMA addObject:aNew];
        }
        sectionNews.newsAry = newsMA.copy;
        
        if (success) {
            success(sectionNews);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
