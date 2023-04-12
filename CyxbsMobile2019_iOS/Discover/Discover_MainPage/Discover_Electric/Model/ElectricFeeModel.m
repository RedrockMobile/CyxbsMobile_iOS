//
//  ElectricFeeModel.m
//  MoblieCQUPT_iOS
//
//  Created by 千千 on 2019/10/28.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import "ElectricFeeModel.h"

@implementation ElectricFeeModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getData];
    }
    return self;
}

- (void)getData {
//    HttpClient *client = [HttpClient defaultClient];
    NSString *building;
    NSString *room;
    
    UserItem *item = [UserItem defaultItem];

    if (item.building && item.room) {
        building = item.building;
        room = item.room;
        NSDictionary *parameters = @{
                @"building": building, @"room": room
        };

        [HttpTool.shareTool
         request:Discover_POST_electricFee_API
         type:HttpToolRequestTypePost
         serializer:HttpToolRequestSerializerHTTP
         bodyParameters:parameters
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            NSLog(@"%@",object);
            ElectricFeeItem *item = [[ElectricFeeItem alloc]initWithDict:object];
            self.electricFeeItem = item;

            //发消息告诉ViewController更新数据
            if (![object[@"elec_inf"][@"room"] isEqual:@""]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeDataSucceed" object:nil];
            } else {
                NSLog(@"可能是房间号输入错误");//发送消息提醒用户重新绑定
                [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRoomFailed" object:nil];
            }
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"电费信息请求失败");//发送消息提醒用户可能是服务器开小差了
            [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeR2equestFailed" object:nil];
        }];
    } else {
        //用户没有绑定，后端尝试读取他以前绑定过的宿舍
        NSDictionary *parameters = @{
                @"building": @"", @"room": @""
        };

        [HttpTool.shareTool
         request:Discover_POST_electricFee_API
         type:HttpToolRequestTypePost
         serializer:HttpToolRequestSerializerHTTP
         bodyParameters:parameters
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            NSLog(@"%@",object);
            ElectricFeeItem *item = [[ElectricFeeItem alloc]initWithDict:object];
            self.electricFeeItem = item;

            //发消息告诉ViewController更新数据
            if (![object[@"elec_inf"][@"room"] isEqual:@""]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeDataSucceed" object:nil];
                NSLog(@"%@", object);
                NSString *buildAndRoom = object[@"elec_inf"][@"room"];
                [UserItem defaultItem].building = [buildAndRoom substringToIndex:2];
                [UserItem defaultItem].room = [buildAndRoom substringFromIndex:3];
                NSLog(@"%@,%@", [UserItem defaultItem].building, [UserItem defaultItem].room);
            } else {
                NSLog(@"可能是房间号输入错误");  //发送消息提醒用户重新绑定
                [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRoomFailed" object:nil];
            }
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"电费信息请求失败");  //发送消息提醒用户可能是服务器开小差了
            [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRequestFailed" object:nil];
        }];
    }
}

@end
