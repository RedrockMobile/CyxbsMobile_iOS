//
//  ExpressDeclareModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressDeclareModel.h"
#import "ExpressDeclareItem.h"

@implementation ExpressDeclareModel

// 表态撤销投票。参数id
- (void)requestDeclareDataWithId:(NSNumber *)theId
                         Success:(void(^)(NSArray *array))success
                         Failure:(void(^)(void))failure {
//    NSDictionary *param = @{
//        @"id": theId
//    };
    [HttpTool.shareTool
    request:Attitude_DELETE_expressDeletePick_API
     type:HttpToolRequestTypeDelete
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:theId
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

@end
