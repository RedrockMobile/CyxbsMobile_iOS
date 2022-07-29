//
//  FansAndFollowersModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/11/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FansAndFollowersModel.h"


@implementation FansAndFollowersModel

+ (void)getDataWithRedid:(NSString *)redid
                 Success:(void (^)(NSArray * _Nonnull, NSArray * _Nonnull))success
                 Failure:(void (^)(void))failure {
    NSDictionary *parameters = @{
        @"redid" : redid
    };
    
    [HttpTool.shareTool
     request:MineMainPage_GET_getFansAndFollowsInfo_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSMutableArray * mAry1 = [NSMutableArray array];
        for(NSDictionary *dict in object[@"data"][@"fans"]){
            FansAndFollowersModel *model = [FansAndFollowersModel mj_objectWithKeyValues:dict];
            [mAry1 addObject:model];
        }
        NSMutableArray * mAry2 = [NSMutableArray array];
        for(NSDictionary *dict in object[@"data"][@"follows"]){
            FansAndFollowersModel *model = [FansAndFollowersModel mj_objectWithKeyValues:dict];
            [mAry2 addObject:model];
        }
        if (success) {
            success([mAry1 copy], [mAry2 copy]);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
    
//    [[HttpClient defaultClient]
//     requestWithPath:MineMainPage_GET_getFansAndFollowsInfo_API
//     method:HttpRequestGet
//     parameters:parameters
//     prepareExecute:nil
//     progress:nil
//     success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSMutableArray * mAry1 = [NSMutableArray array];
//        for(NSDictionary *dict in responseObject[@"data"][@"fans"]){
//            FansAndFollowersModel *model = [FansAndFollowersModel mj_objectWithKeyValues:dict];
//            [mAry1 addObject:model];
//        }
//        NSMutableArray * mAry2 = [NSMutableArray array];
//        for(NSDictionary *dict in responseObject[@"data"][@"follows"]){
//            FansAndFollowersModel *model = [FansAndFollowersModel mj_objectWithKeyValues:dict];
//            [mAry2 addObject:model];
//        }
//
//        success([mAry1 copy], [mAry2 copy]);
//    }
//     failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"failure");
//    }];
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}


@end
