//
//  sendEmailModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "sendEmailModel.h"

@implementation sendEmailModel

- (void)sendEmail:(NSString *)email{
    NSDictionary *param = @{@"email":email};
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:Mine_POST_sendEmailCode_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNetWorkToBindingEmail" object:nil userInfo:nil];
    }];
}


@end
