//
//  DeletePostModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/4/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DeletePostModel.h"

@implementation DeletePostModel

- (void)deletePostWithID:(NSNumber *)postID AndModel:(NSNumber *)model {
    
    NSDictionary *param = @{@"id":postID,@"model":model};
    
    [HttpTool.shareTool
     request:NewQA_POST_QADeletePost_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        self->_Block(object);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_POST_QADeletePost_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        self->_Block(responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
}

@end
