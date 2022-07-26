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
- (void)fetchData {
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:Discover_POST_examArrange_API method:HttpRequestPost parameters:@{@"stuNum":[UserDefaultTool getStuNum]} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        ExamArrangeData *data = [[ExamArrangeData alloc]initWithDic:responseObject];
        self.examArrangeData = data;
        CCLog(@"%@",responseObject);
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"getExamArrangeSucceed" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的考试网络请求失败,%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getExamArrangeFailed" object:nil];

    }];
}
@end
