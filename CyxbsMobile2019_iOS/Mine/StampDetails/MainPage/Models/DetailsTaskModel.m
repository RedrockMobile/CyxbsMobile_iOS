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
    NSString *token = @"eyJEYXRhIjp7ImdlbmRlciI6IueUtyIsInN0dV9udW0iOiIyMDE5MjExNjg1In0sIkRvbWFpbiI6Im1hZ2lwb2tlIiwiUmVkaWQiOiI1NGUxNzEzZTQ5MjUyMTcyNmMzZGQ3ZTg4Mzk1NDcxNzJhZTk1ZTlhIiwiZXhwIjoiNzM5ODcyMTA4NyIsImlhdCI6IjE2Mjg5MDk4MzQiLCJzdWIiOiJ3ZWIifQ==.UhLD0HnnB8M6Zl8K65MrlMVfqDNwXMSOihApTTF4EK46lR/HTuZ1WhlLQfylFPPyqjCNnK+yuuNFJVEemb0e159ZE3iVbRVIAKaGCyWrNUe4lP8lb1EliSbFWW1cP5Kukagfxhs8HX1bqcnFkn4ko2ILEKxF1tFVhTqm1bZ5Hjmdk7aQCC18EyAmb4aryu9E/js/0ESj2UlVb9GBAhnRXV/7xMmgcYL3LSOSu3P08lcfc6HKO6q5wO3BxhR5D0wNAXHFBlBz/EHn0lsspJeUXiYj4h0z/DNyewdA4mDyKIzTkJfFPwj6jKigWLkJFgdBvI1gSXnipOPVGHdc2n0iCA==";
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
