//
//  SportAttendanceModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SportAttendanceModel.h"
#import "SportAttendanceHeader.h"

@implementation SportAttendanceModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sAItemModel = [[SportAttendanceItemModel alloc] init];
    }
    return self;
}

- (void)requestSuccess:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    //获取当前时间
    int nowTime = [[self nowTime] intValue];
    //获取上次加载时间,如果没有值为0
    int loadTime = [[NSUserDefaults.standardUserDefaults objectForKey:@"Sprot_Loadtime"] intValue];
    //现在时间需大于上一次获取时间四小时才进行网络请求
    if (nowTime - loadTime >= 14400) {
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
                //记录下加载时间
                NSString *lodeTime = [self loadTime];
                [NSUserDefaults.standardUserDefaults setObject:lodeTime forKey:@"Sprot_Loadtime"];
                //存下数据(后期需改用WCDB)
                [NSUserDefaults.standardUserDefaults setObject:data forKey:@"Sprot_data"];
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
    }else{
        NSDictionary *data = [NSUserDefaults.standardUserDefaults objectForKey:@"Sprot_data"];
        self.status = 10000;
        self.run_done = [data[@"run_done"] intValue];
        self.run_total = [data[@"run_total"] intValue];
        self.other_done = [data[@"other_done"] intValue];
        self.other_total = [data[@"other_total"] intValue];
        self.award = [data[@"award"] intValue];
        self.sAItemModel = [[SportAttendanceItemModel alloc] initWithArray:data[@"item"]];
        if (success) {
            success();
        }
    }
}

- (NSString *)loadTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (NSString *)nowTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

@end
    
