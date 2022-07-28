//
//  FollowGroupModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "FollowGroupModel.h"

@implementation FollowGroupModel

- (void)FollowGroupWithName:(NSString *)name {
    
    NSDictionary *parameter = @{@"topic_name":name};
    
    [HttpTool.shareTool
     request:NewQA_POST_QAStarGroup_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parameter
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        self->_Block(object);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"关注圈子失败");
        self->_Block(error);
    }];
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_POST_QAStarGroup_API method:HttpRequestPost parameters:parameter prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        self->_Block(responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"关注圈子失败");
//        self->_Block(error);
//    }];
}

@end
