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

- (void)requestJWZXPage:(NSUInteger)page
                success:(void (^)(void))setJWZX
                failure:(void (^) (NSError * error))failure {
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
        
        self.jwzxNews = [[JWZXNewsInformation alloc] initWithDictionary:responseObject];
        
        if (setJWZX) {
            setJWZX();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"🔴JWZX News Model Error:\n%@", error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
