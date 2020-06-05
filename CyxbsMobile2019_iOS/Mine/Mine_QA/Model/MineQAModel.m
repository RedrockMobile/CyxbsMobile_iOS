//
//  MineQAModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/15.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAModel.h"

@implementation MineQAModel

#pragma mark - 我的提问
- (void)requestQuestionListWithPageNum:(NSNumber *)pageNum
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
    [client requestWithPath:MYQUESTIONSAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

#pragma mark - 我的提问（草稿箱）
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

#pragma mark - 我的回答
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

#pragma mark - 我的回答（草稿箱）
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

#pragma mark - 我发出的评论
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

#pragma mark - 我收到的评论
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

#pragma mark - 删除草稿
- (void)deleteDraftWithDraftID:(NSString *)draftID
                     succeeded:(nonnull void (^)(void))succeeded
                        failed:(nonnull void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"stuNum": [UserDefaultTool getStuNum],
        @"idNum": [UserDefaultTool getIdNum],
        @"id": draftID
    };
    
    [[HttpClient defaultClient] requestWithPath:DELETEDRAFT method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        succeeded();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

@end
