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
    NSDictionary *param = @{@"type":@"recommend",@"page":@(page),@"size":@(size)};
    [client requestWithPath:NEW_QA_POST method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        NSLog(@"======>>>>>>>%@",responseObject);
        if ([info isEqualToString:@"success"]) {
            if ([responseObject objectForKey:@"data"] != nil) {
                NSArray *dataArray = [responseObject objectForKey:@"data"];
                self.postArray = [NSMutableArray arrayWithArray:dataArray];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQAListPageDataLoadSuccess" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQAListPageDataLoadError" object:nil];
                NSLog(@"22222222");
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NewQAListDataLoadError"] object:nil];
            NSLog(@"333333333");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NewQAListDataLoadFailure"] object:nil];
        NSLog(@"444444444");
    }];
}
@end

