//
//  PostFocusModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/10/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PostFocusModel.h"

@implementation PostFocusModel

- (void)handleFocusDataWithPage:(NSInteger)page
                      Success:(void (^)(NSArray *arr))success
                      failure:(void(^)(NSError *error))failure {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"page":@(page),@"size":@(6)};
    [client requestWithPath:NEW_QA_FOCUSLIST method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            if ([responseObject objectForKey:@"data"] != nil) {
                NSArray *dataArray = [responseObject objectForKey:@"data"];
                self.postArray = [NSMutableArray arrayWithArray:dataArray];
                success(self.postArray);
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQAListPageDataLoadError" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NewQAListDataLoadError"] object:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
