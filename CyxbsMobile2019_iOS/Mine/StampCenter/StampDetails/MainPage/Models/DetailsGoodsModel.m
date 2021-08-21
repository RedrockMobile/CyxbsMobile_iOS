//
//  DetailsgoodsModel.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsGoodsModel.h"
// network
#import "HttpClient.h"

@implementation DetailsGoodsModel

/// 正式环境网络请求
+ (void)getDataArySuccess:(void (^)(NSArray * array))success
                  failure:(void (^)(void))failure {
    [[HttpClient defaultClient] requestWithPath:Stamp_Store_details_exchange
                                         method:HttpRequestGet
                                     parameters:nil
                                 prepareExecute:nil
                                       progress:nil
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * mAry = [NSMutableArray array];
        for (NSDictionary * dict in responseObject[@"data"]) {
            DetailsGoodsModel * model = [DetailsGoodsModel mj_objectWithKeyValues:dict];
            [mAry addObject:model];
        }
        NSArray * ary = [mAry copy];
        success(ary);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}

@end
