//
//  StampCountData.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "StampCountData.h"
@implementation StampCountData

+ (void)getStampCountData:(void (^)(NSNumber * _Nonnull))success{
    HttpClient *client = [HttpClient defaultClient];
//    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager GET:Stamp_Store_Main_Page parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSNumber *n = responseObject[@"data"][@"user_amonut"];
        success(n);
    } failure:nil];
}

@end
