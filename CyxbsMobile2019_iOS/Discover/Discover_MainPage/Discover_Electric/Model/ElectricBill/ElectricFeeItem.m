//
//  ElectricFeeItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/10.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "ElectricFeeItem.h"

@implementation ElectricFeeItem
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        if (dict[@"elec_inf"][@"elec_cost"][0] == NULL || dict[@"elec_inf"][@"elec_cost"][1] == NULL) {
            self.money = [NSString stringWithFormat:@"0"];
        } else {
            self.money = [NSString stringWithFormat:@"%@.%@", dict[@"elec_inf"][@"elec_cost"][0], dict[@"elec_inf"][@"elec_cost"][1]];
        }
        
        self.degree = [dict[@"elec_inf"][@"elec_spend"] stringValue];
        NSString *returnTime = (NSString *)dict[@"elec_inf"][@"record_time"];
        
        if (![returnTime isEqual:@""]) {
            int month = [returnTime substringToIndex:2].intValue;
            int day = [returnTime substringWithRange:NSMakeRange(3, 2)].intValue;
            self.time = [NSString stringWithFormat:@"2019.%d.%d", month, day];
        }
    }
    return self;
}

@end
