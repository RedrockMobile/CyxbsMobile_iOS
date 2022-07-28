//
//  StarPostModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "StarPostModel.h"

@implementation StarPostModel

- (void)starPostWithPostID:(NSNumber *)postID {
    
    NSDictionary *param = @{@"id":postID,@"model":@"1"};
    
    [HttpTool.shareTool
     request:NewQA_POST_QAStar_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"已点赞");
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];

//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_POST_QAStar_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"已点赞");
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
    
    // 完成拍案叫绝任务
    [HttpTool.shareTool
     form:Mine_POST_task_API
     type:HttpToolRequestTypePost
     parameters:nil
     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
        NSString *target = @"拍案叫绝";
        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
        [body appendPartWithFormData:data name:@"title"];
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"成功了");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了");
    }];
    
    
//    //完成拍案叫绝任务
//    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
//    [client.httpSessionManager POST:Mine_POST_task_API parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *target = @"拍案叫绝";
//        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
//        [formData appendPartWithFormData:data name:@"title"];
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSLog(@"成功了");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"失败了");
//        }];
    
}

@end
