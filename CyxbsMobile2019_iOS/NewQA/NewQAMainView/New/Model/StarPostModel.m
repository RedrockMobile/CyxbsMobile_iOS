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
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"id":postID,@"model":@"1"};
    [client requestWithPath:NEW_QA_STAR method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"已点赞");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
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

@end
