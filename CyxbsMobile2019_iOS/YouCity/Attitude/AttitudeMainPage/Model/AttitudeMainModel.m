//
//  AttitudeMainModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AttitudeMainModel.h"

@implementation AttitudeMainModel


+ (instancetype)initWithDic:(NSDictionary *)dic {
    AttitudeMainModel *model = [[AttitudeMainModel alloc] init];
    model.title = dic[@"id"];
    model.theId = dic[@"title"];
    return model;
}

// json
+ (void)requestAttitudeDataWithSuccess:(void (^)(NSArray * _Nonnull))success
                               Failure:(void (^)(void))falure {
    [HttpTool.shareTool
     request:Attitude_GET_homePageData_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:nil // offset参数未选默认为0，limit默认20
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        NSMutableArray *mutarray = [NSMutableArray array];
        
        for (NSDictionary *dic in object) {
            AttitudeMainModel *model = [AttitudeMainModel initWithDic:dic];
            [mutarray addObject:model];
            NSLog(@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊");
        }
        if (success) {
            success(mutarray.copy);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"=====================表态主页数据获取失败");
    }];
}


@end
