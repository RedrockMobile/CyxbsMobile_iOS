//
//  questionAndAnswerModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "questionAndAnswerModel.h"

@implementation questionAndAnswerModel

- (void)sendQuestionAndAnswerWithId:(NSNumber *) questionid AndContent:(NSString *)content {
    NSDictionary *param = @{@"id":questionid,@"content":content};
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:SENDQUESTION method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
