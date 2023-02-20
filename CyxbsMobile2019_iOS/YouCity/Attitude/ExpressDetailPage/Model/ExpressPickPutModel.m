//
//  ExpressPickPutModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickPutModel.h"
#import "ExpressPickPutItem.h"

@implementation ExpressPickPutModel

// 表态投票 参数id，choices
- (void)requestPickDataWithId:(NSNumber *)theID
                       Choice:(NSString *)choice
                               Success:(void(^)(NSArray *array))success
                               Failure:(void(^)(void))failure {
    NSDictionary *params = @{
        @"id": theID,
        @"choice": choice
    };
    [HttpTool.shareTool
     request:Attitude_PUT_expressPickData_API
     type:HttpToolRequestTypePut
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

@end
