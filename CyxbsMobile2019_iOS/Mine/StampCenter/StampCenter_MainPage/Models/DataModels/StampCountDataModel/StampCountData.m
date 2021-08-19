//
//  StampCountData.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "StampCountData.h"
#import "ZWTMacro.h"
@implementation StampCountData

+ (void)getStampCountData:(void (^)(NSNumber * _Nonnull))success{
    HttpClient *client = [HttpClient defaultClient];
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager GET:MAIN_PAGE_API parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSNumber *n = responseObject[@"data"][@"user_amonut"];
        NSLog(@"%@",n);
        success(n);
    } failure:nil];
}

@end
