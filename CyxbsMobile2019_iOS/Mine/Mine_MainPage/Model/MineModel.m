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
static int cnt = 0;
+ (void)requestQADataSucceeded:(void (^)(MineQADataItem * _Nonnull))succeeded failed:(void (^)(NSError * _Nonnull))failed {
    //这里好像有问题,不知道由于什么原因，[UserDefaultTool getStuNum],有时候会变成nil，
    //导致崩溃，所以在此加一个判断
    if(![UserDefaultTool getStuNum]){
        cnt++;
        if (cnt==5) {
            cnt = 0;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestQADataSucceeded:succeeded failed:failed];
        });
        return;
    }
    cnt = 0;
    
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum]
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:MINEQADATAAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MineQADataItem *item = [[MineQADataItem alloc] initWithDict:responseObject];
        succeeded(item);
        
        // 更新缓存
        [item archiveItem];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
