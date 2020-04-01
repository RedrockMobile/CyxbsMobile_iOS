//
//  QADetailModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailModel.h"

@implementation QADetailModel
- (void)getDataWithId:(NSNumber *)questionId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":questionId};

    [client requestWithToken:QA_QUESTION_DETAIL_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            self.detailData = [responseObject objectForKey:@"data"];

            [self getAnswersWithId:questionId];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadFailure" object:nil];
    }];
}
- (void)getAnswersWithId:(NSNumber *)questionId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":questionId};

    [client requestWithToken:QA_QUESTION_ANSWERLIST method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            self.answersData = [responseObject objectForKey:@"data"];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadFailure" object:nil];
    }];
}
- (void)replyComment:(nonnull NSNumber *)answerId content:(NSString *)content{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answerId,@"content":content};
    [client requestWithToken:QA_ADD_DISCUSS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
//            self.dataDic = [responseObject objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadFailure" object:nil];
    }];
}

- (void)getCommentData:(nonnull NSNumber *)answerId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answerId};
    [client requestWithToken:QA_QUESTION_DISUCESS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
//            self.dataDic = [responseObject objectForKey:@"data"];
        }else{
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
- (void)adoptAnswer:(NSNumber *)questionId answerId:(NSNumber *)answerId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":questionId,@"answer_id":answerId};
    [client requestWithToken:QA_ADOPT_ANSWER_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
//            self.dataDic = [responseObject objectForKey:@"data"];
        }else{
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
- (void)praise:(nonnull NSNumber *)answerId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":answerId};
    [client requestWithToken:QA_ADD_LIKE_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [client requestWithToken:QA_CANCEL_LIKE_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
//            self.dataDic = [responseObject objectForKey:@"data"];
        }else{
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)report:(NSString *)type question_id:(NSNumber *)question_id{
    NSDictionary *parameters = @{@"question_id":question_id,@"type":type};
    [[HttpClient defaultClient] requestWithToken:QA_ADD_REPORT_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailReportSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailReportError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailReportFailure" object:nil];
    }];
}
- (void)ignore:(NSNumber *)question_id{
    NSDictionary *parameters = @{@"question_id":question_id};
    [[HttpClient defaultClient] requestWithToken:QA_IGNORE_QUESTION_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailIgnoreSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailIgnoreError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailIgnoreFailure" object:nil];
    }];
}
@end
