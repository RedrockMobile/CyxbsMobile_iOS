//
//  DynamicDetailRequestDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DynamicDetailRequestDataModel.h"

@implementation DynamicDetailRequestDataModel
- (void)starCommentWithComent_id:(int)comment_id Sucess:(void (^)(void))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    //model为2表示这是评论点赞
    NSDictionary *param = @{@"id":@(comment_id),@"model":@2};
    [client requestWithPath:NEW_QA_STAR method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        sucess();
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure();
        }];
    //完成拍案叫绝任务
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *target = @"拍案叫绝";
        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:data name:@"title"];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"成功了");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败了");
        }];
}

- (void)requestDynamicDetailDataWithDynamic_id:(int)dynamic_id Sucess:(void (^)(NSDictionary * _Nonnull))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"id":@(dynamic_id)};
    [client requestWithPath:NEW_QA_DynamicDetail method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        sucess(dic);
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure();
        }];
    
        //完成逛逛邮问任务
        [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
        [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *target = @"逛逛邮问";
            NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:data name:@"title"];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"成功了");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"失败了");
            }];
    
}

- (void)getCommentDataWithPost_id:(int)post_id Sucess:(void (^)(NSArray * _Nonnull))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:NEW_QA_Comment_Reply method:HttpRequestGet parameters:@{@"post_id":@(post_id)} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"];
//        NSLog(@"请求评论数据成功,内容为%@",responseObject);
        sucess(array);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure();
        }];
}

- (void)reportCommentWithId:(int)comment_id Content:(NSString *)content Sucess:(void (^)(void))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    //请求参数字典
    NSDictionary *param = @{@"id":@(comment_id),@"model":@1,@"content":content};

    [client requestWithPath:NEW_QA_REPORT method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            sucess();
        }else{
            failure();
        }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure();
        }];
}

- (void)deleteCommentWithId:(int)post_id Sucess:(void (^)(void))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"id":@(post_id),@"model":@1};
//    @"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/comment/deleteId"
    [client requestWithPath:NEW_QA_Dynamic_OR_Comment_Deleted method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"删除评论后得到的数据为%@",responseObject);
        if ([responseObject[@"status"] intValue] == 200) {
            NSLog(@"删除成功");
            sucess();
        }else{
            failure();
        }
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
            NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
                NSLog(@"错误信息-------%@",str);
            }

            failure();
        }];
}

- (void)deletSelfDynamicWithID:(int)post_id Success:(void(^)(void))success Failure:(void(^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"id":@(post_id),@"model":@0};
    [client requestWithPath:NEW_QA_DELETEPOST method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            success();
        }else{
            failure();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}
@end
