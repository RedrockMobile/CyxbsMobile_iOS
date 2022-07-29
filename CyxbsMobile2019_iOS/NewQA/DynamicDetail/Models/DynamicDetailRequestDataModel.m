//
//  DynamicDetailRequestDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DynamicDetailRequestDataModel.h"

@implementation DynamicDetailRequestDataModel
- (void)starCommentWithComent_id:(int)comment_id Success:(void (^)(void))success Failure:(void (^)(void))failure {
    
    //model为2表示这是评论点赞
    NSDictionary *param = @{@"id":@(comment_id),@"model":@2};
    
    [HttpTool.shareTool
     request:NewQA_POST_QAStar_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_POST_QAStar_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        success();
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            failure();
//        }];
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

- (void)requestDynamicDetailDataWithDynamic_id:(int)dynamic_id Success:(void (^)(NSDictionary * _Nonnull))success Failure:(void (^)(void))failure{
    
    NSDictionary *param = @{@"id":@(dynamic_id)};
    
    [HttpTool.shareTool
     request:NewQA_GET_QADynamicDetail_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSDictionary *dic = object[@"data"];
        if (success) {
            success(dic);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"动态详情页加载失败");
        if (failure) {
            failure();
        }
    }];
    

//    HttpClient *client = [HttpClient defaultClient];
//
//    [client requestWithPath:NewQA_GET_QADynamicDetail_API method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = responseObject[@"data"];
//        success(dic);
//
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"动态详情页加载失败");
//            failure();
//        }];
    
    // 完成逛逛邮问任务
    [HttpTool.shareTool
     form:Mine_POST_task_API
     type:HttpToolRequestTypePost
     parameters:nil
     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
        NSString *target = @"逛逛邮问";
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
    
//        [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
//        [client.httpSessionManager POST:Mine_POST_task_API parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            NSString *target = @"逛逛邮问";
//            NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
//            [formData appendPartWithFormData:data name:@"title"];
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                NSLog(@"成功了");
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"失败了");
//            }];
    
}

- (void)getCommentDataWithPost_id:(int)post_id Success:(void (^)(NSArray * _Nonnull))success Failure:(void (^)(void))failure {
    
    [HttpTool.shareTool
     request:NewQA_GET_QACommentReply_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{@"post_id":@(post_id)}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSArray *array = object[@"data"];
//        NSLog(@"请求评论数据成功,内容为%@",responseObject);
        if (success) {
            success(array);
        }

    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_GET_QACommentReply_API method:HttpRequestGet parameters:@{@"post_id":@(post_id)} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSArray *array = responseObject[@"data"];
////        NSLog(@"请求评论数据成功,内容为%@",responseObject);
//        success(array);
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            failure();
//        }];
}

- (void)reportCommentWithId:(int)comment_id Content:(NSString *)content Success:(void (^)(void))success Failure:(void (^)(void))failure{
    
    //请求参数字典
    NSDictionary *param = @{@"id":@(comment_id),@"model":@1,@"content":content};
    
    [HttpTool.shareTool
     request:NewQA_POST_QAReport_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        if ([object[@"status"] intValue] == 200) {
            if (success) {
                success();
            }
        }else {
            if (failure) {
                failure();
            }
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
    

//    [[HttpClient defaultClient] requestWithPath:NewQA_POST_QAReport_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject[@"status"] intValue] == 200) {
//            success();
//        }else{
//            failure();
//        }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            failure();
//        }];
}

- (void)deleteCommentWithId:(int)post_id Success:(void (^)(void))success Failure:(void (^)(void))failure {
    //    @"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/comment/deleteId"
    
    NSDictionary *param = @{@"id":@(post_id),@"model":@1};
    
    [HttpTool.shareTool
     request:NewQA_POST_QADynamicOrCommentDeleted_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"删除评论后得到的数据为%@", object);
        if ([object[@"status"] intValue] == 200) {
            NSLog(@"删除成功");
            if (success) {
                success();
            }
        }else {
            if (failure) {
                failure();
            }
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
        NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
            NSLog(@"错误信息-------%@",str);
        }
        if (failure) {
            failure();
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//        [client requestWithPath:NewQA_POST_QADynamicOrCommentDeleted_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"删除评论后得到的数据为%@",responseObject);
//        if ([responseObject[@"status"] intValue] == 200) {
//            NSLog(@"删除成功");
//            success();
//        }else{
//            failure();
//        }
//
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
//            NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
//            NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
//                NSLog(@"错误信息-------%@",str);
//            }
//
//            failure();
//        }];
}

- (void)deleteSelfDynamicWithID:(int)post_id Success:(void(^)(void))success Failure:(void(^)(void))failure {
    
    NSDictionary *param = @{@"id":@(post_id),@"model":@0};
    
    [HttpTool.shareTool
     request:NewQA_POST_QADeletePost_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        if ([object[@"status"] intValue] == 200) {
            if (success) {
                success();
            }
        }else {
            if (failure) {
                failure();
            }
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_POST_QADeletePost_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject[@"status"] intValue] == 200) {
//            success();
//        }else{
//            failure();
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failure();
//    }];
}
@end
