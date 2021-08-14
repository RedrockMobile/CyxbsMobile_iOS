//
//  DetailsgoodsModel.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsGoodsModel.h"

@implementation DetailsGoodsModel

+ (NSArray *)getDataList {
    NSMutableArray * mAry = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        DetailsGoodsModel * model = [[DetailsGoodsModel alloc] init];
        model.goods_price = 400 + i;
        model.date = 1628834025 + i * 100;
        model.is_received = NO;
        model.goods_name = [NSString stringWithFormat:@"签到了%d", i];
        model.order_id = [NSString stringWithFormat:@"order_id_%d", i];
        [mAry addObject:model];
    }
    return mAry.copy;
}

@end
