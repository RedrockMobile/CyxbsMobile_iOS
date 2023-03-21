//
//  ExpressPickGetModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickGetModel.h"
#import "ExpressPickGetItem.h"

@implementation ExpressPickGetModel

// 获取表态页详细信息 参数id
- (void)requestGetDetailDataWithId:(NSNumber *)theId
                           Success:(void(^)(NSArray *array))success
                           Failure:(void(^)(void))failure {
    NSDictionary *param = @{ @"id": theId };
    [HttpTool.shareTool
    request:Attitude_GET_expressDetailData_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        ExpressPickGetItem *model = [[ExpressPickGetItem alloc] initWithDic:object];
        NSMutableArray *dataArray = [NSMutableArray array];
        [dataArray addObject:model];
        if (success) {
            success(dataArray.copy);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure-----------");
    }];
}

@end
