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
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"id":postID,@"model":model,@"content":str};
    [client requestWithPath:NewQA_POST_report_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
}

@end
