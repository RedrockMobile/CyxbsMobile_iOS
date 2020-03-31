//
//  EditMyInfoPresneter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoPresenter.h"

@implementation EditMyInfoPresenter

- (void)uploadProfile:(UIImage *)profile success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum]
    };
    
    [[HttpClient defaultClient] uploadImageWithJson:UPLOADPROFILEAPI method:HttpRequestPost parameters:params imageArray:@[profile] prepareExecute:nil progress:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)attachView:(EditMyInfoViewController *)view {
    _attachedViwe = view;
}

- (void)dettatchView {
    _attachedViwe = nil;
}

@end
