//
//  CQUPTMapModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapModel.h"
#import "CQUPTMapDataItem.h"

@implementation CQUPTMapModel

+ (void)requestMapDataSuccess:(void (^)(CQUPTMapDataItem * _Nonnull, NSArray<CQUPTMapHotPlaceItem *> * _Nonnull))success failed:(void (^)(NSError * _Nonnull))failed {
    
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPBASICDATA method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            
            // 继续请求热词
            [self requestHotPlaceSuccess:^(NSArray<CQUPTMapHotPlaceItem *> * _Nonnull hotPlaceItemArray) {
                CQUPTMapDataItem *mapDataItem = [[CQUPTMapDataItem alloc] initWithDict:responseObject];
                success(mapDataItem, hotPlaceItemArray);
            }];
            
        } else {
            failed([[NSError alloc] init]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

+ (void)requestHotPlaceSuccess:(void (^)(NSArray<CQUPTMapHotPlaceItem *> * _Nonnull))success {
    
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPHOTPLACE method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"][@"button_info"]) {
                CQUPTMapHotPlaceItem *hotPlaceItem = [[CQUPTMapHotPlaceItem alloc] initWithDict:dict];
                [tmpArray addObject:hotPlaceItem];
            }
            success(tmpArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

@end
