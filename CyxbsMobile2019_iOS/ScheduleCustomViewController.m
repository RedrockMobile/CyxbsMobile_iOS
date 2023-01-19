//
//  ScheduleCustomViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleCustomViewController.h"

#import "HttpTool.h"

@interface ScheduleCustomViewController ()

@end

@implementation ScheduleCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)test {
    [HttpTool.shareTool
    request:@"https://be-prod.redrock.cqupt.edu.cn/magipoke/token" type:HttpToolRequestTypePost serializer:HttpToolRequestSerializerJSON bodyParameters:@{
        @"stuNum" : @"2021215154",
        @"idNum" : @"062411"
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"%@", object);
    } failure:nil];
}

@end
