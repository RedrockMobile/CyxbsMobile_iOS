//
//  questionAndEmail.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "questionAndEmail.h"

@implementation questionAndEmail

- (void)isBindEmailAndQuestion {
    NSDictionary *param = @{@"stu_num":[UserDefaultTool getStuNum]};
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:BINDINGEMAILANDQUESTIONAPI method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
