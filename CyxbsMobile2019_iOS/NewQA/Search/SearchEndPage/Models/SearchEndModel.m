//
//  SearchEndModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SearchEndModel.h"

@implementation SearchEndModel
- (void)loadRelevantDynamicDataWithStr:(NSString *)str Page:(NSInteger)page Sucess:(void (^)(NSArray * _Nonnull))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"key":str ,@"page":@(page) ,@"size":@6};
    [client requestWithPath:NEWQA_SEARCH_DYNAMIC_API method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"加载动态列表数据成功");
        NSArray *ary = responseObject[@"data"];
        sucess(ary);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure();
        }];
}
@end
