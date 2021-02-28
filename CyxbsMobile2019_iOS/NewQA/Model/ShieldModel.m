//
//  ShieldModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ShieldModel.h"

@implementation ShieldModel

- (void)ShieldPersonWithUid:(NSString *)uid {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"uid":uid};
    [client requestWithPath:NEW_QA_SHIELD method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
}

@end
