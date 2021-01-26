//
//  SZHSearchDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHSearchDataModel.h"

@implementation SZHSearchDataModel
- (void)getHotArayWithProgress:(void (^)(NSArray * _Nonnull))progress{
   __block NSMutableArray *hotSearchTextFieldAry = [NSMutableArray array];
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/search/getSearchHotWord" method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"-----热词请求成功");
      
        NSDictionary *dic = responseObject[@"data"];
        NSArray *tmpArray = dic[@"hot_words"];
        for (NSString *hotWord in tmpArray) {
            [hotSearchTextFieldAry addObject:hotWord];
        }
        progress(hotSearchTextFieldAry);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"------请求失败");
        NSArray *array = @[@1,@2,@3];
        hotSearchTextFieldAry = array;
        progress(hotSearchTextFieldAry);
    }];
}
@end
