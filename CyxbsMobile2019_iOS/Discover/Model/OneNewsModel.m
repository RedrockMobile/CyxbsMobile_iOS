//
//  OneNewsModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "OneNewsModel.h"

@implementation OneNewsModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getData];
    }
    return self;
}
- (void)getData {
    HttpClient *client = [HttpClient defaultClient];

    NSDictionary *parameters = @{@"page":@1};
    [client requestWithPath:NEWSLIST method:HttpRequestGet parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.title = responseObject[@"data"][0][@"title"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"oneNewsSucceed" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"教务新闻请求失败");
    }];
    
}
@end
