//
//  QAReviewModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAReviewModel.h"

@implementation QAReviewModel
- (void)getDataWithId:(NSNumber *)answerId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answerId};

    [client requestWithPath:QA_QUESTION_DISUCESS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            self.reviewData = [responseObject objectForKey:@"data"];

      
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewDataLoadSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewDataLoadError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewDataLoadFailure" object:nil];
    }];
}

- (void)replyComment:(NSString *)content answerId:(NSNumber *)answerId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answerId,@"content":content};
    [client requestWithPath:QA_ADD_DISCUSS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewDataReLoad" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewReplyCommentError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewReplyCommentFailure" object:nil];
    }];
}

- (void)praise:(nonnull NSNumber *)answerId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answerId};
    [client requestWithPath:QA_ADD_LIKE_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
//            self.dataDic = [responseObject objectForKey:@"data"];
        }else{
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
- (void)cancelPraise:(nonnull NSNumber *)answerId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answerId};
    [client requestWithPath:QA_CANCEL_LIKE_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
//            self.dataDic = [responseObject objectForKey:@"data"];
        }else{
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)report:(NSString *)type answer_id:(NSNumber *)answer_id{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answer_id,@"type":type};
    [client requestWithPath:QA_ADD_REPORT_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewReportSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewReportError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewReportFailure" object:nil];
    }];
}
- (void)ignore:(NSNumber *)answer_id{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answer_id};
    [client requestWithPath:QA_IGNORE_QUESTION_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewIgnoreSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewIgnoreError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAReviewIgnoreFailure" object:nil];
    }];
}
@end
