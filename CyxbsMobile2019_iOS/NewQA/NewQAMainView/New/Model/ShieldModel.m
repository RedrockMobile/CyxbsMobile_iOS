//
//  ShieldModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ShieldModel.h"

@implementation ShieldModel

- (void)ShieldPersonWithUid:(NSString *)uid {
    
    NSDictionary *param = @{@"uid":uid};
    
    [HttpTool.shareTool
     request:NewQA_POST_QAShield_API
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
//    [client requestWithPath:NewQA_POST_QAShield_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        self->_Block(responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
}

@end
