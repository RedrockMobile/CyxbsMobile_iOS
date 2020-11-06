//
//  sendCodeModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/3.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "sendCodeModel.h"

@implementation sendCodeModel

- (void)sendCode:(NSString *)code ToEmail:(NSString *)email{
    NSDictionary *param = @{@"email":email,@"code":code};
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:EMAILCODEAPI method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
