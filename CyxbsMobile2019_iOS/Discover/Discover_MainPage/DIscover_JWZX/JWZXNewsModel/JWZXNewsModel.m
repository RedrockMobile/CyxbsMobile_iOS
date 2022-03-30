//
//  JWZXNewsModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXNewsModel.h"

#pragma mark - JWZXNewsModel

@implementation JWZXNewsModel

- (void)GET_JWZXPage:(NSUInteger)page success:(void (^)(void))setJWZX {
    NSDictionary *parameters = @{
        @"page" : [NSNumber numberWithLong:page]
    };
    
    [HttpClient.defaultClient
     requestWithPath:NEWSLIST
     method:HttpRequestGet
     parameters:parameters
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"🟢JWZX:\n%@", responseObject);
        
        self.jwzxNews = [[JWZXNews alloc] initWithDictionary:responseObject];
        
        setJWZX();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"🔴JWZX ERROR:\n%@", error);
    }];
}

@end
