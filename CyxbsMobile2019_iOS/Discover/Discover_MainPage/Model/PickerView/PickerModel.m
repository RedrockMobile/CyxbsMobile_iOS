//
//  PickerModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PickerModel.h"

@implementation PickerModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeArray = @[@"宁静苑",@"明理苑",@"知行苑",@"兴业苑",@"四海苑"];
        self.siHaiPlace = @[@"1舍",@"2舍"];
        self.ningJingPlace = @[@"1舍",@"2舍",@"3舍",@"4舍",@"5舍",@"6舍",@"7舍",@"8舍",@"9舍"];
        self.mingLiPlace = @[@"1舍",@"2舍",@"3舍",@"4舍",@"5舍",@"6舍",@"7舍",@"8舍",@"9舍"];
        self.zhiXingPlace = @[@"1舍",@"2舍",@"3舍",@"4舍",@"5舍",@"6舍",@"7舍",@"8舍",@"9舍"];
        self.xingYePlace = @[@"1舍",@"2舍",@"3舍",@"4舍",@"5舍",@"6舍",@"7舍",@"8舍"];
        self.allArray = @[self.ningJingPlace,self.mingLiPlace,self.zhiXingPlace,self.xingYePlace,self.siHaiPlace];
    }
    return self;
}
- (NSString *)getNumberOfDormitoryWith:(NSString *)building andPlace:(NSString *)place {
    NSLog(@"%@",[place substringToIndex:1]);
    NSLog(@"%@",place);
    int num = [place substringToIndex:1].intValue;
    if ([building isEqual: @"宁静苑"]) {
        if (num >= 1 && num <= 5) {
            num += 7;
        }else if (num>=6) {
            num += 26;
        }else {
            
        }
    }
    else if ([building isEqual:@"明理苑"]) {
        if(num >= 1 && num <= 8) {
            num += 23;
        }else {
            num += 30;
        }
    }
    else if ([building isEqual:@"知行苑"]) {
        if(num >= 1 && num <= 6) {
            
        }else {
            num += 8;
        }
    }
    else if([building isEqual:@"兴业苑"]) {
        if (num >= 1 && num <= 6) {
            num += 16;
        }else if (num == 7) {
            return @"23A栋";
        }else if (num == 8) {
            return @"23B栋";
        }
    }
    else {//四海苑
        num += 35;
    }
    return [NSString stringWithFormat:@"%2d栋",num];
}
@end
