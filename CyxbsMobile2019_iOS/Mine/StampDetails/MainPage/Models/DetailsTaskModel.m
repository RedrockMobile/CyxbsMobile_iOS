//
//  DetailsTaskModel.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsTaskModel.h"

@implementation DetailsTaskModel

+ (NSArray *)getDatalist {
    NSMutableArray * mAry = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 22; i++) {
        DetailsTaskModel * model = [[DetailsTaskModel alloc] init];
        model.task_name = [NSString stringWithFormat:@"卷卷鼠标垫%d", i];
        model.date = [NSString stringWithFormat:@"2021-7-%d", i];
        model.task_income = 40 + i;
        [mAry addObject:model];
    }
    return mAry.copy;
}

@end
