//
//  ExpressPickPutItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickPutItem.h"

@implementation ExpressPickPutItem
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.percentNumArray = [NSArray array];
        self.putStatistic = dic[@"statistic"]; // 字典 { string: number }
        self.putVoted = dic[@"voted"];
    }
    return self;
}

/// 小数数组（使用时需要将NSNumber 转换成CGFloat）
- (void)votedPercenteCalculateToNSNumber:(NSDictionary *)staticDic {
    NSInteger total = 0;
    NSArray *valueArray = [staticDic allValues];
    for (int i = 0; i < valueArray.count; ++i) {
        total += (long)valueArray[i];
    }
    NSMutableArray *tempMa = [NSMutableArray array];
    for (int j = 0; j < valueArray.count; ++j) {
        NSInteger percentInteger = (long)valueArray[j] / total;
        NSNumber *percentNum = [NSNumber numberWithInteger:percentInteger];
        [tempMa addObject:percentNum];
    }
    self.percentNumArray = tempMa;
}
@end
