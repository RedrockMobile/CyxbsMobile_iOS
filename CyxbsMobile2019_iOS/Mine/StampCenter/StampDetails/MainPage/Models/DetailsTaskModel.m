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

/// 正式环境
+ (void)getDataAryWithPage:(NSInteger)page
                      Size:(NSInteger)size
                   Success:(void (^)(NSArray * _Nonnull))success
                   failure:(void (^)(void))failure {
    NSDictionary * dict = @{
        @"page" : @(page),
        @"size" : @(size)
    };
    [[HttpClient defaultClient] requestWithPath:Stamp_store_details_getRecord
                                         method:HttpRequestGet
                                     parameters:dict
                                 prepareExecute:nil
                                       progress:nil
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray * mAry = [NSMutableArray array];
        for (NSDictionary * dict in responseObject[@"data"]) {
            DetailsTaskModel * model = [DetailsTaskModel mj_objectWithKeyValues:dict];
            [mAry addObject:model];
        }
        NSArray * ary = [mAry copy];
        success(ary);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        failure();
    }];

}

@end
