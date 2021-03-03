//
//  RemarkModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RemarkModel.h"

@implementation RemarkModel
- (void)loadMoreData {
    NSString *url = @"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/user/replyme";
    NSDictionary *paramDict = @{
        @"page":@"1",
        @"size":@"1",
        @"type":@"2"
    };
    
    [self.client requestWithPath:url method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
@end
