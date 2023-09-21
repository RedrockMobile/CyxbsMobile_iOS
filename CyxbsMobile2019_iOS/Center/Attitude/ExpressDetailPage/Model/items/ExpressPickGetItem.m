//
//  ExpressPickGetItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickGetItem.h"

@implementation ExpressPickGetItem
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.percentStrArray = [NSArray array];
        self.percentNumArray = [NSArray array];
        self.getId = dic[@"id"];
        self.choices = dic[@"choices"];
        self.getStatistic = dic[@"statistic"]; // 也是字典 { string: number }
        self.title = dic[@"title"];
        self.choices = dic[@"choices"];
    }
    return self;
}

/// 把获取到的static 数据里的投票情况转化为小数占比
- (NSArray *)votedPercentCalculateToString:(NSDictionary *)staticDic {
    NSInteger total = 0;
    NSArray *valueArray = [staticDic allValues];
    for (int i = 0; i < valueArray.count; ++i) {
        total += (long)valueArray[i];
    }
    NSMutableArray *tempMa = [NSMutableArray array];
    for (int j = 0; j < valueArray.count; ++j) {
        NSInteger percentInteger = (long)valueArray[j] / total;
        CGFloat percentFloat = percentInteger / 100.0; // 将 NSInteger 转换为浮点数类型
        NSString *formattedString = [NSString stringWithFormat:@"%.2f%%", percentFloat * 100]; // 将浮点数格式化为带两位小数的字符串，并拼接上百分号
        [tempMa addObject:formattedString];
    }
    valueArray = tempMa;
    return valueArray;
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
