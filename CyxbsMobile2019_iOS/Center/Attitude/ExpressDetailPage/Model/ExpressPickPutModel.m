//
//  ExpressPickPutModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickPutModel.h"

@implementation ExpressPickPutModel

// 表态投票 参数id，choices
- (void)requestPickDataWithId:(NSNumber *)theID
                       Choice:(NSString *)choice
                               Success:(void(^)(ExpressPickPutItem *model))success
                               Failure:(void(^)(NSError * _Nonnull))failure {
    NSDictionary *params = @{
        @"id": theID,
        @"choice": choice
    };
    [HttpTool.shareTool
     request:Center_PUT_AttitudeExpressPick_API
     type:HttpToolRequestTypePut
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSInteger status = [object[@"status"] intValue];
        if (status == 10000) {
            ExpressPickPutItem *pickModel = [[ExpressPickPutItem alloc] initWithDictionary:object];
            [pickModel votedPercenteCalculateToNSNumber:pickModel.putStatistic];
            if (success) {
                success(pickModel);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error);
        }
    }];
}

@end
