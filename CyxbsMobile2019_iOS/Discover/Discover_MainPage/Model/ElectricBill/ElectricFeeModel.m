//
//  ElectricFeeModel.m
//  MoblieCQUPT_iOS
//
//  Created by 千千 on 2019/10/28.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import "ElectricFeeModel.h"

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
    [client requestWithPath:ELECTRICFEE method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        ElectricFeeItem *item = [[ElectricFeeItem alloc]initWithDict:responseObject];
        self.electricFeeItem = item;
        //发消息告诉ViewController更新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeDataSucceed" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"电费信息请求失败");
    }];
    
}

@end
