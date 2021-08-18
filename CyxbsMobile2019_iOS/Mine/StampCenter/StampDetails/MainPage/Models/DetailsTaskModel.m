//
//  DetailsTaskModel.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsTaskModel.h"
// network
#import "HttpClient.h"

@implementation DetailsTaskModel

///// 正式环境
//+ (void)getDataAryWithPage:(NSInteger)page
//                      Size:(NSInteger)size
//                   Success:(void (^)(NSArray * _Nonnull))success
//                   failure:(void (^)(void))failure {
//NSDictionary * dict = @{
//    @"page" : @(page),
//    @"size" : @(size)
//};
//    [[HttpClient defaultClient] requestWithPath:Stamp_store_details_getRecord
//                                         method:HttpRequestGet
//                                     parameters:dict
//                                 prepareExecute:nil
//                                       progress:nil
//                                        success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSMutableArray * mAry = [NSMutableArray array];
//            for (NSDictionary * dict in responseObject[@"data"]) {
//                DetailsTaskModel * model = [DetailsTaskModel mj_objectWithKeyValues:dict];
//                [mAry addObject:model];
//            }
//            NSArray * ary = [mAry copy];
//            success(ary);
//    }
//                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
//}


/// 测试环境
+ (void)getDataAryWithPage:(NSInteger)page
                      Size:(NSInteger)size
                   Success:(void (^)(NSArray * _Nonnull))success
                   failure:(void (^)(void))failure {
    NSString *token = @"eyJEYXRhIjp7ImdlbmRlciI6IueUtyIsInN0dV9udW0iOiIyMDIwMjEyMDk1In0sIkRvbWFpbiI6Im1hZ2lwb2tlIiwiUmVkaWQiOiJjMmI2ZjFjOTFiMmQ5NDcyOGE5ZDQyYzQ5NjFkZDkxOWY0NWFiYWI0IiwiZXhwIjoiNzM5OTA3NDk3NiIsImlhdCI6IjE2MjkyNjM3MjMiLCJzdWIiOiJ3ZWIifQ==.EPuOwJRWN7qTuj2/loJPCdJhVAsFJajpTm6kWXYIhX1NaeG+sa9ETubIPCttO1r0/Qwu1qC3NZJp1vWXcxhGc69wyw09Xqa3QFgT09Ylegnq9gjQt/zO/rFGQT+oLE+Y7TafYAY06PXcHU+i7lIWc+rwIFLvPV3Q1y4JFhV0dwAlkLHUz7a/BP6c5dadhCuBBZJrGKyVE2aLfMH9PxzseDS7QRQVia5ZmqEqMbnTlgKrWYgRlef2otl63bHhK9KsbNwEfKPGq9A5RM7l/nRBd1aeC27+3IoMIy7cdivcCpNcBAv4KuP7c6+LIR4JLlzldM0w6v6XNTghyW07DIcwHw==";
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token]  forHTTPHeaderField:@"authorization"];
    NSDictionary * dict = @{
        @"page" : @(page),
        @"size" : @(size)
    };
    [manager GET:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-intergral/User/getRecord" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSMutableArray * mAry = [NSMutableArray array];
        for (NSDictionary * dict in responseObject[@"data"]) {
            DetailsTaskModel * model = [DetailsTaskModel mj_objectWithKeyValues:dict];
            [mAry addObject:model];
        }
        NSArray * ary = [mAry copy];
        success(ary);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];

}

@end
