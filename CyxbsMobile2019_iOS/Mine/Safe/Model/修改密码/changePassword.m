//
//  changePassword.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/2.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "changePassword.h"

@implementation changePassword

- (void)changePasswordWithNewPassword:(NSString *)password {
    NSDictionary *param = @{@"origin_password":password,@"new_password":password};
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:CHANGEPASSWORDAPI method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
