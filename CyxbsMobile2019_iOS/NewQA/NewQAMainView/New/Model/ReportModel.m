//
//  ReportModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ReportModel.h"

@implementation ReportModel

///此处封装好了，举报评论也可以直接用，model换成2就行
- (void)ReportWithPostID:(NSNumber *)postID WithModel:(NSNumber *)model AndContent:(NSString *)str {
    
    NSDictionary *param = @{@"id":postID,@"model":model,@"content":str};
    
//    [HttpTool.shareTool
//     request:NewQA_POST_report_API
//     type:HttpToolRequestTypePost
//     serializer:HttpToolRequestSerializerHTTP
//     bodyParameters:param
//     progress:nil
//     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
//        self->_Block(object);
//    }
//     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:NewQA_POST_report_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

@end
