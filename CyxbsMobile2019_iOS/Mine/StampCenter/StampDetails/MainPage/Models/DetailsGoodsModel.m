//
//  DetailsgoodsModel.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsGoodsModel.h"
// network
#import "HttpClient.h"
// 字典转模型
#import <MJExtension.h>

@implementation DetailsGoodsModel

///// 正式环境网络请求
//+ (void)getDataArySuccess:(void (^)(NSArray * array))success
//                  failure:(void (^)(NSString * failureStr))failure {
//    [[HttpClient defaultClient] requestWithPath:Stamp_Store_details_exchange
//                                         method:HttpRequestGet
//                                     parameters:nil
//                                 prepareExecute:nil
//                                       progress:nil
//                                        success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSMutableArray * mAry = [NSMutableArray array];
//        for (NSDictionary * dict in responseObject[@"data"]) {
//            DetailsGoodsModel * model = [DetailsGoodsModel mj_objectWithKeyValues:dict];
//            [mAry addObject:model];
//        }
//        NSArray * ary = [mAry copy];
//        success(ary);
//    } failure:nil];
//}

/// 测试环境 ! ! !
+ (void)getDataArySuccess:(void (^)(NSArray * _Nonnull))success
                  failure:(void (^)(void))failure {
    NSString *token = @"eyJEYXRhIjp7ImdlbmRlciI6IueUtyIsInN0dV9udW0iOiIyMDIwMjEyMDk1In0sIkRvbWFpbiI6Im1hZ2lwb2tlIiwiUmVkaWQiOiJjMmI2ZjFjOTFiMmQ5NDcyOGE5ZDQyYzQ5NjFkZDkxOWY0NWFiYWI0IiwiZXhwIjoiNzM5OTA3NDk3NiIsImlhdCI6IjE2MjkyNjM3MjMiLCJzdWIiOiJ3ZWIifQ==.EPuOwJRWN7qTuj2/loJPCdJhVAsFJajpTm6kWXYIhX1NaeG+sa9ETubIPCttO1r0/Qwu1qC3NZJp1vWXcxhGc69wyw09Xqa3QFgT09Ylegnq9gjQt/zO/rFGQT+oLE+Y7TafYAY06PXcHU+i7lIWc+rwIFLvPV3Q1y4JFhV0dwAlkLHUz7a/BP6c5dadhCuBBZJrGKyVE2aLfMH9PxzseDS7QRQVia5ZmqEqMbnTlgKrWYgRlef2otl63bHhK9KsbNwEfKPGq9A5RM7l/nRBd1aeC27+3IoMIy7cdivcCpNcBAv4KuP7c6+LIR4JLlzldM0w6v6XNTghyW07DIcwHw==";
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token]  forHTTPHeaderField:@"authorization"];
    
    [manager GET:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-intergral/User/exchange" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSMutableArray * mAry = [NSMutableArray array];
//        for (NSDictionary * dict in responseObject[@"data"]) {
//            DetailsGoodsModel * model = [DetailsGoodsModel mj_objectWithKeyValues:dict];
//            [mAry addObject:model];
//        }
        for (int i = 0; i < 20; i++) {
            DetailsGoodsModel * model = [[DetailsGoodsModel alloc] init];
            model.goods_name = [NSString stringWithFormat:@"name--%d", i];
            model.goods_price = i+100;
            model.order_id = [NSString stringWithFormat:@"idid--%d", 111 + i];
            model.is_received = i % 2;
            model.date = 1628834025 + 100 * i;
            [mAry addObject:model];
        }
        NSArray * ary = [mAry copy];
        success(ary);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];
}

@end
