//
//  QADetailModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailModel.h"

@implementation QADetailModel
-(void)getDataWithId:(NSNumber *)questionId{
    HttpClient *client = [HttpClient defaultClient];
//    NSDictionary *parameters = @{@"question_id":questionId,@"stuNum":[UserDefaultTool getStuNum],@"idNum":[UserDefaultTool getIdNum]};
    //测试数据
    NSDictionary *parameters = @{@"question_id":@1088,@"stuNum":[UserDefaultTool getStuNum],@"idNum":[UserDefaultTool getIdNum]};
    [client requestWithPath:QA_QUESTION_DETAIL_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            self.dataDic = [responseObject objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataLoadFailure" object:nil];
    }];
}
@end
