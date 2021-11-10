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
    NSString *building;
    NSString *room;
    
    UserItem *item = [UserItem defaultItem];
    if (item.building && item.room) {
        building = item.building;
           room = item.room;
        NSDictionary *parameters = @{@"building":building, @"room":room};
        [client requestWithPath:ELECTRICFEE method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"%@",responseObject);
            ElectricFeeItem *item = [[ElectricFeeItem alloc]initWithDict:responseObject];
            self.electricFeeItem = item;
            //发消息告诉ViewController更新数据
            if (![responseObject[@"elec_inf"][@"room"]  isEqual: @""]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeDataSucceed" object:nil];
            }else {
                NSLog(@"可能是房间号输入错误");//发送消息提醒用户重新绑定
                [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRoomFailed" object:nil];
            }
           
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"电费信息请求失败");//发送消息提醒用户可能是服务器开小差了
            [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRequestFailed" object:nil];
        }]; 
    }else {
        //用户没有绑定，后端尝试读取他以前绑定过的宿舍
        NSDictionary *parameters = @{@"building":@"", @"room":@""};
               [client requestWithPath:ELECTRICFEE method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                   NSLog(@"%@",responseObject);
                   ElectricFeeItem *item = [[ElectricFeeItem alloc]initWithDict:responseObject];
                   self.electricFeeItem = item;
                   //发消息告诉ViewController更新数据
                   if (![responseObject[@"elec_inf"][@"room"]  isEqual: @""]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeDataSucceed" object:nil];
                       NSLog(@"%@",responseObject);
                       NSString *buildAndRoom = responseObject[@"elec_inf"][@"room"];
                       [UserItem defaultItem].building = [buildAndRoom substringToIndex:2];
                       [UserItem defaultItem].room = [buildAndRoom substringFromIndex:3];
                       NSLog(@"%@,%@",[UserItem defaultItem].building,[UserItem defaultItem].room);
                   }else {
                       NSLog(@"可能是房间号输入错误");//发送消息提醒用户重新绑定
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRoomFailed" object:nil];
                   }
                  
               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                   NSLog(@"电费信息请求失败");//发送消息提醒用户可能是服务器开小差了
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRequestFailed" object:nil];
               }];
    }

    
}

@end
