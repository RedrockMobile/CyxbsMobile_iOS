//
//  AttitudeSelfPageModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/3/19.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AttitudeSelfPageModel.h"
#import "AttitudeSelfPageItem.h"

@implementation AttitudeSelfPageModel
- (void)requestAttitudePermissionWithSuccess:(void(^)(NSArray *array))success
                                     Failure:(void(^)(void))failure {
    
    [HttpTool.shareTool
     request:@"https://metersphere.redrock.team/mock/100002/declare/perm"
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSLog(@"%@",object);
        NSLog(@"%@",object[@"data"]);
        AttitudeSelfPageItem *item = [AttitudeSelfPageItem initWithDic:object[@"data"]];
        [dataArray addObject:item];
        if (success) {
            success(dataArray.copy);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"鉴权failure");
    }];
}
@end
