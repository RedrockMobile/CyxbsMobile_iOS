//
//  ElectricFeeModel.m
//  MoblieCQUPT_iOS
//
//  Created by 千千 on 2019/10/28.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import "ElectricFeeModel.h"
#define URL @"https://cyxbsmobile.redrock.team/MagicLoop/index.php?s=/addon/ElectricityQuery/ElectricityQuery/queryElecByRoom"
@implementation ElectricFeeModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getData];
    }
    return self;
}
- (void)getData {
    HttpClient *client = [HttpClient defaultClient];
    NSString *building = @"26";
    NSString *room = @"412";
    NSDictionary *parameters = @{@"building":building, @"room":room};
    [client requestWithPath:URL method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.money = [NSString stringWithFormat:@"%@.%@",responseObject[@"elec_inf"][@"elec_cost"][0],responseObject[@"elec_inf"][@"elec_cost"][1]];
        self.degree = responseObject[@"elec_inf"][@"elec_spend"];
        //接口返回了06月21日
        NSString *returnTime = (NSString*)responseObject[@"elec_inf"][@"record_time"];
        int month = [returnTime substringToIndex:1].intValue;
        int day = [returnTime substringWithRange:NSMakeRange(3, 2)].intValue;
        self.time = [NSString stringWithFormat:@"2019.%d.%d",month,day];
        NSLog(@"%@",responseObject);
        //发消息告诉ViewModel更新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeDataSucceed" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求电费网络错误！");
    }];
    
}
@end
