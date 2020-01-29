//
//  MineModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineModel.h"
#import "MineQADataItem.h"

@implementation MineModel

+ (void)requestQADataSucceeded:(void (^)(MineQADataItem * _Nonnull))succeeded failed:(void (^)(NSError * _Nonnull))failed {
//    NSDictionary *params = @{
//        @"stunum": [UserDefaultTool getStuNum],
//        @"idNum": [UserDefaultTool getIdNum]
//    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MINEQADATAAPI method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MineQADataItem *item = [[MineQADataItem alloc] initWithDict:responseObject];
        succeeded(item);
        
        // 更新缓存
        [item archiveItem];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
