//
//  QAListModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAListModel.h"

@implementation QAListModel
-(void)loadData:(NSString *)kind page:(NSInteger)page{
    if (!self.dataDictionary) {
        self.dataDictionary = [NSMutableDictionary dictionary];
        NSArray *titleArray = @[@"最新",@"学习",@"匿名",@"生活",@"其他"];
        for (int i = 0; i < titleArray.count; i++) {
            NSMutableArray *arr = [NSMutableArray array];
            [self.dataDictionary setValue:arr forKey:titleArray[i]];
        }
    }
    
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"kind":kind,@"page":@(page)};
    [client requestWithToken:QA_ALL_QUESTIONS_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            
            if ([responseObject objectForKey:@"data"] != nil) {
                NSArray *dataArray = [responseObject objectForKey:@"data"];
                if (page == 1) {
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObjectsFromArray:dataArray];
                    [self.dataDictionary setValue:arr forKey:kind];
                }else{
                NSMutableArray *arr = [self.dataDictionary valueForKey:kind];
                    [arr addObjectsFromArray:dataArray];
                    [self.dataDictionary setValue:arr forKey:kind];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"QAList%@DataLoadSuccess",kind] object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"QAList%@MoreDataLoadError",kind] object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"QAListDataLoadError"] object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"QAListDataLoadFailure"] object:nil];
    }];
}
@end
