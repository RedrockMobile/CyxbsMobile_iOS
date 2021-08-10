//
//  DetailsCommodityModel.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsCommodityModel.h"

@implementation DetailsCommodityModel

+ (NSArray *)getDataList {
    NSMutableArray * mAry = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        DetailsCommodityModel * model = [[DetailsCommodityModel alloc] init];
        model.price = 400 + i;
        model.date = [NSString stringWithFormat:@"2020-6-%d", i];
        model.isCollected = NO;
        model.moment = [NSString stringWithFormat:@"14:%d", i];
        model.commodity_name = [NSString stringWithFormat:@"签到了%d", i];
        model.order_id = [NSString stringWithFormat:@"order_id_%d", i];
        [mAry addObject:model];
    }
    return mAry.copy;
}

@end
