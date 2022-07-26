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
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum]
    };
    
    HttpClient *client = [HttpClient defaultClient];
    
    [client requestWithPath:Mine_POST_checkIn_API method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    
        
        [self requestCheckInInfoWithParams:params succeeded:succeded];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

+ (void)requestCheckInInfoWithParams:(NSDictionary *)params succeeded:(void (^)(void))succeded {
    HttpClient *client = [HttpClient defaultClient];
    
    [client requestWithPath:Mine_POST_checkInInfo_API method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [UserItemTool defaultItem].checkInDay = responseObject[@"data"][@"check_in_days"];
        [UserItemTool defaultItem].integral = responseObject[@"data"][@"integral"];
        [UserItemTool defaultItem].rank = responseObject[@"data"][@"rank"];
        [UserItemTool defaultItem].rank_Persent = responseObject[@"data"][@"percent"];
        [UserItemTool defaultItem].week_info = responseObject[@"data"][@"week_info"];
        [UserItemTool defaultItem].canCheckIn = [responseObject[@"data"][@"can_check_in"] boolValue];
        [UserItemTool defaultItem].isCheckedToday = [responseObject[@"data"][@"is_check_today"] boolValue];
        succeded();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
