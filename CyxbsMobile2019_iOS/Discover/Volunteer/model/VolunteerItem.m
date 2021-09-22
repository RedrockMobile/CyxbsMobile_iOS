//
//  QueryDataModel.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 12/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//
//

#import "VolunteerItem.h"
#import "ArchiveTool.h"

@implementation VolunteerItem

MJExtensionCodingImplementation

- (void)getVolunteerInfoWithUserName:(NSString *)userName andPassWord:(NSString *)passWord finishBlock:(void (^)(VolunteerItem *volunteer))finish {
    
    NSLog(@"--%@--", [self aesEncrypt:passWord]);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8.f;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];
    [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserItemTool defaultItem].token]  forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *bindParams = @{
        @"account": userName,
        @"password": [self aesEncrypt:passWord],
    };
    
    [manager POST:VOLUNTEERBIND parameters:bindParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [manager POST:VOLUNTEERREQUEST parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:10];
                for (NSDictionary *dict in responseObject[@"record"]) {
                    VolunteeringEventItem *volEvent = [[VolunteeringEventItem alloc] initWithDictinary:dict];
                    [temp addObject:volEvent];
                }
                self.eventsArray = temp;
                [self sortEvents];
                
                float hour = 0;
                int count = 0;
                for (VolunteeringEventItem *event in self.eventsArray) {
                    hour += [event.hour floatValue];
                    count++;
                }
                self.hour = [NSString stringWithFormat:@"%.1f",hour];
                self.count = [NSString stringWithFormat:@"%d",count];
                
                [ArchiveTool saveVolunteerInfomationWith:self];
                finish(self);
                NSLog(@"志愿信息查询成功");
                HttpClient *client = [HttpClient defaultClient];
                //完成绑定志愿者账号任务 (需要绑定成功)
                [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
                [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSString *target = @"绑定志愿者账号";
                    NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
                    [formData appendPartWithFormData:data name:@"title"];
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSLog(@"成功了");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"失败了");
                    }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }else if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
            NSLog(@"志愿网服务异常");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QueryVolunteerInfoFailed" object:nil];
        }else if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:-2]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QueryVolunteerInfoFailed" object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QueryVolunteerInfoFailed" object:nil];
        NSLog(@"志愿信息绑定失败");
    }];
}

// 加密
-(NSString *)aesEncrypt:(NSString *)plainText{
    NSString *secretkey = @"redrockvolunteer";
    NSString *cipherText = aesEncryptString(plainText, secretkey);
    return cipherText;
}
//2020年5月10日log：从老版本迁移过来的时候编译此方法会有bug，但是此方法并为被调用所以注释掉了

// 将志愿活动按时间排序
- (void)sortEvents {
    // 获取当前时间
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    long year=[components year];
    
    NSMutableArray *allEvents = [NSMutableArray array];
    NSMutableArray *eventInOneYear = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        for (VolunteeringEventItem *event in self.eventsArray) {
            NSString *creatTime = [event.start_time substringToIndex:4];
            NSInteger totalhour = 0;
            if ([creatTime isEqualToString:[NSString stringWithFormat:@"%ld", year - i]]) {
                totalhour += [event.hour intValue];
                event.creatTime = creatTime;
                [eventInOneYear addObject:event];
            }
        }
        [allEvents addObject:[eventInOneYear mutableCopy]];
        [eventInOneYear removeAllObjects];
    }
    
    self.eventsSortedByYears = allEvents;
}

@end
