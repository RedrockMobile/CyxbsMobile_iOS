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
    [HttpTool.shareTool
     request:Mine_POST_checkIn_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        [self requestCheckInInfoSucceeded:succeded Failed:failed];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
}

+ (void)requestCheckInInfoSucceeded:(void (^)(void))success Failed:(void (^)(NSError * _Nonnull))failed {
    
    [HttpTool.shareTool
     request:Mine_POST_checkInInfo_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSInteger status = [object[@"status"] intValue];
        if (status == 10000) {
            [UserItemTool defaultItem].checkInDay = object[@"data"][@"check_in_days"];
            [UserItemTool defaultItem].integral = object[@"data"][@"integral"];
            [UserItemTool defaultItem].rank = object[@"data"][@"rank"];
            [UserItemTool defaultItem].rank_Persent = object[@"data"][@"percent"];
            [UserItemTool defaultItem].week_info = object[@"data"][@"week_info"];
            [UserItemTool defaultItem].canCheckIn = [object[@"data"][@"can_check_in"] boolValue];
            [UserItemTool defaultItem].isCheckedToday = [object[@"data"][@"is_check_today"] boolValue];
        }        
        if (success) {
            success();
        }

    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
}

@end
