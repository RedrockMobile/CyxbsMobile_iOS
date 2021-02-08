//
//  PostModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PostModel.h"
#import "PostArchiveTool.h"

@implementation PostModel

MJCodingImplementation

- (void)loadMainPostWithPage:(NSInteger)page AndSize:(NSInteger)size {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"topic":@"main",@"page":@(page),@"size":@(size)};
    [client requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/post/getDynamicList" method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            if ([responseObject objectForKey:@"data"] != nil) {
                NSArray *dataArray = [responseObject objectForKey:@"data"];
                self.postArray = [NSMutableArray arrayWithArray:dataArray];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQAListPageDataLoadSuccess" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQAListPageDataLoadError" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NewQAListDataLoadError"] object:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NewQAListDataLoadFailure"] object:nil];
    }];
}
@end

