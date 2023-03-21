//
//  ExpressPickGetModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickGetModel.h"

@implementation ExpressPickGetModel

// 获取表态页详细信息 参数id
- (void)requestGetDetailDataWithId:(NSNumber *)theId
                           Success:(void(^)(ExpressPickGetItem *model))success
                           Failure:(void(^)(void))failure {
    
    [HttpTool.shareTool
    request:Attitude_GET_expressDetailData_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:theId
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        ExpressPickGetItem *model = [[ExpressPickGetItem alloc] initWithDic:object];
        // 转换成百分比字符数组
        [model votedPercentCalculateToString:model.getStatistic];
        [model votedPercenteCalculateToNSNumber:model.getStatistic];
        if (success) {
            success(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

@end
