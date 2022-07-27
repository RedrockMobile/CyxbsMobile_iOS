//
//  ArticleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/2.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

- (void)loadMoreData {
    NSString *size = @"6";
    NSDictionary *paramDict = @{
        @"page":@(self.page),
        @"size":size,
    };
    
    [HttpTool.shareTool
     request:Mine_GET_getArticle_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:paramDict
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        [self.dataArr addObjectsFromArray:object[@"data"]];
        
        if ([object[@"data"] count]<size.integerValue) {
            [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateNoMoreDate];
        }else {
            [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateEndRefresh];
        }
        self.page++;
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.delegate mainPageModelLoadDataFinishWithState:MainPageModelStateFailure];
    }];
}

- (void)deleteArticleWithID:(NSString*)ID {
    NSDictionary *paramDict = @{
        @"id":ID,
        @"model":@"0"
    };
    
    [HttpTool.shareTool
     request:Mine_POST_deleteArticle_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:paramDict
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            NSDictionary *dict;
            for (int i=0; i<self.dataArr.count; i++) {
                dict = self.dataArr[i];
                if ([dict[@"post_id"] isEqualToString:ID]) {
                    [self.dataArr removeObject:dict];
                    break;
                }
            }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.delegate deleteArticleFailure];
        }];
}
@end
