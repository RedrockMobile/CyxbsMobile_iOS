//
//  SportAttendanceModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SportAttendanceModel.h"

@implementation SportAttendanceModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sAItemModel = [[SportAttendanceItemModel alloc] init];
    }
    return self;
}

- (void)requestSuccess:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    
    [HttpTool.shareTool
     request:Discover_GET_SportAttendance_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"🟢%@:\n%@", self.class, object);
        self.status = [object[@"status"] intValue];
        if (self.status == 10000) {
            NSDictionary *data = object[@"data"];
            self.run_done = [data[@"run_done"] intValue];
            self.run_total = [data[@"run_total"] intValue];
            self.other_done = [data[@"other_done"] intValue];
            self.other_total = [data[@"other_total"] intValue];
            self.award = [data[@"award"] intValue];
            self.sAItemModel = [[SportAttendanceItemModel alloc] initWithArray:data[@"item"]];
        }
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"🔴%@:\n%@", self.class, error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
    
