//
//  CheckInModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CheckInModel.h"

@implementation CheckInModel

+ (void)CheckInSucceeded:(void (^)(void))succeded Failed:(void (^)(NSError * _Nonnull))failed {
    if (UserItemTool.defaultItem.stuNum && [NSUserDefaults.standardUserDefaults stringForKey:@"idNum"]) {
        NSDictionary *params = @{
            @"stunum": UserItemTool.defaultItem.stuNum,
            @"idnum": [NSUserDefaults.standardUserDefaults stringForKey:@"idNum"]
        };
        
        [HttpTool.shareTool
         request:Mine_POST_checkIn_API
         type:HttpToolRequestTypePost
         serializer:HttpToolRequestSerializerHTTP
         bodyParameters:params
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            [self requestCheckInInfoWithParams:params succeeded:succeded];
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failed(error);
        }];
    } else {
        // 处理参数为nil的情况
        NSError *error = [NSError errorWithDomain:@"CheckIn" code:0 userInfo:@{NSLocalizedDescriptionKey: @"参数为空"}];
        failed(error);
    }
}

+ (void)requestCheckInInfoWithParams:(NSDictionary *)params succeeded:(void (^)(void))succeded {
    
    [HttpTool.shareTool
     request:Mine_POST_checkInInfo_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        [UserItemTool defaultItem].checkInDay = object[@"data"][@"check_in_days"];
        [UserItemTool defaultItem].integral = object[@"data"][@"integral"];
        [UserItemTool defaultItem].rank = object[@"data"][@"rank"];
        [UserItemTool defaultItem].rank_Persent = object[@"data"][@"percent"];
        [UserItemTool defaultItem].week_info = object[@"data"][@"week_info"];
        [UserItemTool defaultItem].canCheckIn = [object[@"data"][@"can_check_in"] boolValue];
        [UserItemTool defaultItem].isCheckedToday = [object[@"data"][@"is_check_today"] boolValue];
        succeded();
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
