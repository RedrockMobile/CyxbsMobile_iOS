//
//  ExamArrangeModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ExamArrangeModel.h"

@implementation ExamArrangeModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fetchData];
    }
    return self;
}
//[CyxbsMobileBaseURL_1 stringByAppendingString:@"renewapi/examSchedule"]
- (void)fetchData {
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:EXAMARRANGEAPI method:HttpRequestPost parameters:@{@"stuNum":[UserDefaultTool getStuNum]} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        ExamArrangeData *data = [[ExamArrangeData alloc]initWithDic:responseObject];
        self.examArrangeData = data;
        CCLog(@"%@",responseObject);
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"getExamArrangeSucceed" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getExamArrangeFailed" object:nil];

    }];
}
@end
