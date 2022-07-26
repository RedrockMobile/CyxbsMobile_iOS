//
//  questionAndEmail.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "questionAndEmail.h"

@implementation questionAndEmail

///请求判断用户是否绑定了密保或者邮箱
- (void)isBindEmailAndQuestion {
    NSDictionary *param = @{@"stu_num":[UserDefaultTool getStuNum]};
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:Mine_POST_bindingEmailAndQuestion_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",[responseObject[@"status"] class]);
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败");
    }];
}

@end
