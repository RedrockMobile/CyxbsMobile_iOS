//
//  ClassmatesList.m
//  MoblieCQUPT_iOS
//
//  Created by 方昱恒 on 2019/9/27.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import "ClassmatesList.h"

@implementation ClassmatesList

- (void)getListWithName:(NSString *)name success:(void (^)(ClassmatesList * _Nonnull))succeededCallBack failure:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failedCallBack  {
    
    NSDictionary *parameters = @{@"stu": name};
    HttpClient *client = [HttpClient defaultClient];
    
    [client requestWithPath:SEARCHPEOPLEAPI method:HttpRequestGet parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (NSDictionary *classmateInfo in responseObject[@"data"]) {
            ClassmateItem *classmate = [ClassmateItem classmateWithDictionary:classmateInfo];
            [tmpArray addObject:classmate];
        }
        self.classmatesArray = tmpArray;
        succeededCallBack(self);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failedCallBack(task, error);
    }];
}

@end
