//
//  questionModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "questionModel.h"


@implementation questionModel

- (void)loadQuestionList {
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:QUESTIONLISTAPI method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNetWorkToGetQuestionList" object:nil userInfo:nil];
    }];
}


@end

