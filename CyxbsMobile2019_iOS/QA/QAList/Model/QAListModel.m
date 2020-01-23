//
//  QAListModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAListModel.h"

@implementation QAListModel{
    NSInteger status;
}
-(void)getData{
//    NSArray *titleArray = @[@"最新",@"学习",@"匿名",@"生活",@"更多"];
    //学习数据返回错误，先用生活
    NSArray *titleArray = @[@"全部",@"生活",@"匿名",@"生活",@"更多"];
    self->status = 0;
    self.dataArray = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        [self.dataArray addObject:[NSMutableArray array]];
        HttpClient *client = [HttpClient defaultClient];
        NSDictionary *parameters = @{@"kind":titleArray[i],@"stunum":[UserDefaultTool getStuNum],@"idnum":[UserDefaultTool getIdNum]};
        [client requestWithPath:QA_ALL_QUESTIONS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *info = [responseObject objectForKey:@"info"];
            if ([info isEqualToString:@"success"]) {
                
                if ([responseObject objectForKey:@"data"] != nil) {
                    self.dataArray[i] = [responseObject objectForKey:@"data"];
                }
                
                [self checkDataLoadStatus];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QAListDataLoadError" object:nil];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAListDataLoadFailure" object:nil];
        }];
    }
}
-(void)checkDataLoadStatus{
    self->status += 1;
    if (self->status == 4) {
//        NSLog(@"%d,%@",self.dataArray.count,self.dataArray[0]);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"QAListDataLoadSuccess" object:nil];
    }
}
@end
