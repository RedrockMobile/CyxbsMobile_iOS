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
    
    NSDictionary *param = @{@"loop":@(loop),@"page":@(page),@"size":@(size),@"type":type};
    
    [HttpTool.shareTool
     request:NewQA_GET_QATopicContent_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSString *info = [object objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            if ([object objectForKey:@"data"] != nil) {
                NSArray *dataArray = [object objectForKey:@"data"];
                self.postArray = [NSMutableArray arrayWithArray:dataArray];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicDataLoadSuccess" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicDataLoadFailure" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"TopicDataLoadFailure"] object:nil];
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"TopicDataLoadFailure"] object:nil];
    }];

//    HttpClient *client = [HttpClient defaultClient];
//
//    [client requestWithPath:NewQA_GET_QATopicContent_API method:HttpRequestGet parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSString *info = [responseObject objectForKey:@"info"];
//        if ([info isEqualToString:@"success"]) {
//            if ([responseObject objectForKey:@"data"] != nil) {
//                NSArray *dataArray = [responseObject objectForKey:@"data"];
//                self.postArray = [NSMutableArray arrayWithArray:dataArray];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicDataLoadSuccess" object:nil];
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicDataLoadFailure" object:nil];
//            }
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"TopicDataLoadFailure"] object:nil];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"TopicDataLoadFailure"] object:nil];
//    }];
}

@end
