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
    [client requestWithPath:Stamp_Store_Main_Page method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *n = responseObject[@"data"][@"user_amonut"];
        success(n);
    } failure:nil];
}

@end
