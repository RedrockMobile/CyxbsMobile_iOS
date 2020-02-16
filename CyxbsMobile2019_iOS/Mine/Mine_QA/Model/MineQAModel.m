//
//  MineQAModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/15.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAModel.h"

@implementation MineQAModel

- (void)requestQuestionListWithPageNum:(NSNumber *)pageNum
                           andPageSize:(NSNumber *)size
                             succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
                                failed:(void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"stunum": @"2017210129",
        @"idnum": @"034214",
        @"page": pageNum.stringValue,
        @"size": size.stringValue
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MYQUESTIONSAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        succeeded(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

- (void)requestQuestionDraftListWithPageNum:(NSNumber *)pageNum
                                andPageSize:(NSNumber *)size
                                  succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
                                     failed:(void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"stuNum": [UserDefaultTool getStuNum],
        @"idNum": [UserDefaultTool getIdNum],
        @"page": pageNum.stringValue,
        @"size": size.stringValue
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MYQUESTIONDRAFTAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

- (void)requestAnswerListWithPageNum:(NSNumber *)pageNum
                         andPageSize:(NSNumber *)size
                           succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
                              failed:(void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum],
        @"page": pageNum.stringValue,
        @"size": size.stringValue
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MYANSWERSAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

- (void)requestAnswerDraftListWithPageNum:(NSNumber *)pageNum
                              andPageSize:(NSNumber *)size
                                succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
                                   failed:(void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"stuNum": [UserDefaultTool getStuNum],
        @"idNum": [UserDefaultTool getIdNum],
        @"page": pageNum.stringValue,
        @"size": size.stringValue
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MYANSWERSDRAFTAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

- (void)requestCommentListWithPageNum:(NSNumber *)pageNum
                          andPageSize:(NSNumber *)size
                            succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
                               failed:(void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum],
        @"page": pageNum.stringValue,
        @"size": size.stringValue
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MYCOMMENTAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

- (void)requestReCommentListWithPageNum:(NSNumber *)pageNum
                            andPageSize:(NSNumber *)size
                              succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
                                 failed:(void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum],
        @"page": pageNum.stringValue,
        @"size": size.stringValue
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MYRECOMMENTAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

@end
