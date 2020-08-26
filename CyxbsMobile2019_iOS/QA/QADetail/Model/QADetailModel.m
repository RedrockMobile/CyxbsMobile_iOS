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

    [client requestWithPath:QA_QUESTION_DETAIL_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    
    [client requestWithPath:QA_BROWSENUMBER_API method:HttpRequestPost parameters:@{@"id": questionId} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 统计阅读量，失败了就算了，懒得写
    }];
}
- (void)getAnswersWithId:(NSNumber *)questionId{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{
        @"question_id":questionId,
    };
    //@"question_id":@1473
    
    [client requestWithPath:QA_QUESTION_ANSWERLIST method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            self.answersData = [[responseObject objectForKey:@"data"] mutableCopy];

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
    [client requestWithPath:QA_ADD_DISCUSS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [client requestWithPath:QA_QUESTION_DISUCESS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [client requestWithPath:QA_ADOPT_ANSWER_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)report:(NSString *)type question_id:(NSNumber *)question_id{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":question_id,@"type":type};
    [client requestWithPath:QA_ADD_REPORT_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":question_id};
    [client requestWithPath:QA_IGNORE_QUESTION_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
- (void)getAnswersWithId:(NSNumber *)questionId AndPage:(NSNumber*)page{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{
        @"question_id":questionId,
        @"page":page
    };
    //@"question_id":@1473
    
    [client requestWithPath:QA_QUESTION_ANSWERLIST method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            
            [self.answersData addObjectsFromArray:[responseObject objectForKey:@"data"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadMoreSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadMoreError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadMoreFailure" object:nil];
    }];
}
- (NSMutableArray *)answersData{
    if(_answersData==nil){
        _answersData = [NSMutableArray array];
    }
    return _answersData;
}
@end
