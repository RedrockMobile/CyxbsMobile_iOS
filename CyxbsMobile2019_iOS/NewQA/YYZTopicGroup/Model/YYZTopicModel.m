//
//  YYZTopicModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2021/4/10.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "YYZTopicModel.h"

@implementation YYZTopicModel

- (void)loadTopicWithLoop:(NSInteger)loop AndPage:(NSInteger)page AndSize:(NSInteger)size AndType:(NSString *)type {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"loop":@(loop),@"page":@(page),@"size":@(size),@"type":type};
    [client requestWithPath:NEW_QA_TOPICCONTENT method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            if ([responseObject objectForKey:@"data"] != nil) {
                NSArray *dataArray = [responseObject objectForKey:@"data"];
                self.postArray = [NSMutableArray arrayWithArray:dataArray];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicDataLoadSuccess" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicDataLoadError" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"TopicLoadError"] object:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"TopicLoadFailure"] object:nil];
    }];
}

@end
