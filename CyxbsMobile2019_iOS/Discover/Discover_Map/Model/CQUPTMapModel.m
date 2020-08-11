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

+ (void)requestMapDataSuccess:(void (^)(CQUPTMapDataItem * _Nonnull, CQUPTMapHotPlaceItem * _Nonnull))success failed:(void (^)(NSError * _Nonnull))failed {
    
    [[HttpClient defaultClient] requestWithPath:@"https://www.fastmock.site/mock/42a89553a15999d575ea56f4f9a84fd1/apiTest/api/mapData" method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        CQUPTMapDataItem *mapDataItem = [[CQUPTMapDataItem alloc] initWithDict:responseObject];
        success(mapDataItem, [[CQUPTMapHotPlaceItem alloc] init]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

+ (void)requestHotPlaceSuccess:(void (^)(CQUPTMapHotPlaceItem * _Nonnull))success {
    
}

@end
