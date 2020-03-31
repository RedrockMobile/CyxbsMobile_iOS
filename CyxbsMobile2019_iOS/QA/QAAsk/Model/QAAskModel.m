//
//  QAAskModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskModel.h"

@implementation QAAskModel
-(void)commitAsk:(NSString *)title content:(NSString *)content kind:(NSString *)kind reward:(NSString *)reward disappearTime:(NSString *)disappearTime imageArray:(NSArray *)imageArray{
    NSLog(@"s");
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"description":content,@"title":title,@"kind":kind,@"reward":reward,@"disappear_time":disappearTime};
    [client requestWithToken:QA_ADD_QUESTION_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            self.questionId = [dic objectForKey:@"id"];
            if (imageArray.count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitSuccess" object:nil];
            }else{
                [self uploadPhoto:imageArray];
            }
            
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitFailure" object:nil];
    }];
}

-(void)uploadPhoto:(NSArray *)photoArray{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":self.questionId};
    [client uploadImageWithJson:QA_UPLOAD_PIC_API method:HttpRequestPost parameters:parameters imageArray:photoArray prepareExecute:nil progress:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitSuccess" object:nil];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitError" object:nil];
        }
        
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSDictionary *dic = [operation.responseObject objectForKey:@"info"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitFailure" object:nil];
    }];
    
}
@end
