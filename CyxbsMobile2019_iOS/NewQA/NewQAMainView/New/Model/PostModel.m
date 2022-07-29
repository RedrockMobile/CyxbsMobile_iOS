//
//  PostModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PostModel.h"
#import "PostArchiveTool.h"
#import "PostTableViewCellFrame.h"

@implementation PostModel

MJCodingImplementation

- (void)handleDataWithPage:(NSInteger)page
                   Success:(void (^)(NSArray *arr))success
                   failure:(void(^)(NSError *error))failure {
    
    NSDictionary *param = @{@"type":@"recommend", @"page":@(page), @"size":@(6)};
    
    [HttpTool.shareTool
     request:NewQA_GET_QAPost_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSString *info = [object objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            if ([object objectForKey:@"data"] != nil) {
                NSArray *dataArray = [object objectForKey:@"data"];
                self.postArray = [NSMutableArray arrayWithArray:dataArray];
                if (success) {
                    success(self.postArray);
                }
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQAListPageDataLoadError" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NewQAListDataLoadError"] object:nil];
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_QAPost_API method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSString *info = [responseObject objectForKey:@"info"];
//        if ([info isEqualToString:@"success"]) {
//            if ([responseObject objectForKey:@"data"] != nil) {
//                NSArray *dataArray = [responseObject objectForKey:@"data"];
//                self.postArray = [NSMutableArray arrayWithArray:dataArray];
//                success(self.postArray);
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQAListPageDataLoadError" object:nil];
//            }
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NewQAListDataLoadError"] object:nil];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failure(error);
//    }];
}
@end

