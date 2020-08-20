//
//  CQUPTMapModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapModel.h"
#import "CQUPTMapStarPlaceItem.h"

@implementation CQUPTMapModel

+ (void)requestMapDataSuccess:(void (^)(CQUPTMapDataItem * _Nonnull, NSArray<CQUPTMapHotPlaceItem *> * _Nonnull))success
                       failed:(void (^)(NSError * _Nonnull))failed {
    
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPBASICDATA method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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

+ (void)requestStarListSuccess:(void (^)(CQUPTMapStarPlaceItem * _Nonnull))success
                        failed:(void (^)(NSError * _Nonnull))failed {
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPMYSTAR method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            
            CQUPTMapStarPlaceItem *item = [[CQUPTMapStarPlaceItem alloc] initWithDice:responseObject];
            
            success(item);
        } else if ([responseObject[@"data"] isEqualToString:@""]) {
            // 这里后端的逻辑很奇怪，没有收藏的时候data本来应该是@{}，但是却返回了一个@""，并且status是500。
            // 所以这里只有单独写一个判断了。
            CQUPTMapStarPlaceItem *item = [[CQUPTMapStarPlaceItem alloc] init];
            
            success(item);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (void)searchPlaceWithString:(NSString *)string
                      success:(nonnull void (^)(NSArray<CQUPTMapSearchItem *> * _Nonnull))success
                       failed:(nonnull void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"code": string
    };
    
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPSEARCH method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (int i = 0; i < [responseObject[@"data"] count]; i++) {
            CQUPTMapSearchItem *item = [[CQUPTMapSearchItem alloc] initWithID:[responseObject[@"data"][i] intValue]];
            [tmpArray addObject:item];
        }
        success(tmpArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (void)requestPlaceDataWithPlaceID:(NSString *)placeID success:(nonnull void (^)(CQUPTMapPlaceDetailItem * _Nonnull))success failed:(nonnull void (^)(NSError * _Nonnull))failed {
    NSDictionary *params = @{
        @"place_id": placeID
    };
    
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPPLACEDETAIL method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            CQUPTMapPlaceDetailItem *item = [[CQUPTMapPlaceDetailItem alloc] initWithDict:responseObject[@"data"]];
            item.placeID = placeID;
            success(item);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (void)starPlaceWithPlaceID:(NSString *)placeID {
    NSDictionary *params = @{
        @"place_id": placeID
    };
    
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPADDCOLLECT method:HttpRequestPatch parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        CQUPTMapStarPlaceItem *item = [NSKeyedUnarchiver unarchiveObjectWithFile:[CQUPTMapStarPlaceItem archivePath]];
        [item.starPlaceArray addObject:placeID];
        [item archiveItem];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (void)deleteStarPlaceWithPlaceID:(NSString *)placeID {
    NSDictionary *params = @{
        @"place_id": placeID
    };
    
    [[HttpClient defaultClient] requestWithPath:CQUPTMAPDELETECOLLECT method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        CQUPTMapStarPlaceItem *item = [NSKeyedUnarchiver unarchiveObjectWithFile:[CQUPTMapStarPlaceItem archivePath]];
        [item.starPlaceArray removeObject:placeID];
        [item archiveItem];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
