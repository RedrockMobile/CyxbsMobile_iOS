//
//  QAAnswerModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAnswerModel.h"

@implementation QAAnswerModel
-(void)commitAnswer:(NSNumber *)questionId content:(NSString *)content{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":questionId,@"stuNum":[UserDefaultTool getStuNum],@"idNum":[UserDefaultTool getIdNum],@"content":content};
    //测试数据
    [client requestWithPath:QA_ANSWER_QUESTION_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
//            self.dataDic = [responseObject objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitFailure" object:nil];
    }];
}

@end
