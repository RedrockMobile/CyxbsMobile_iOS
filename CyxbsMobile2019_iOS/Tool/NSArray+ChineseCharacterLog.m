//
//  NSArray+ChineseCharacterLog.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/5.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NSArray+ChineseCharacterLog.h"

@implementation NSArray (ChineseCharacterLog)

#ifdef DEBUG
-(NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *string = [NSMutableString string];

    // 开头有个[
    [string appendString:@"[\n"];

    // 遍历所有的元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];

    // 结尾有个]
    [string appendString:@"]"];

    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound){
        [string deleteCharactersInRange:range];
    }
    return string;
}
#endif

@end
