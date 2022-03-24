//
//  NSDictionary+ChineseCharacterLog.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/5.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NSDictionary+ChineseCharacterLog.h"

@implementation NSDictionary (ChineseCharacterLog)

#ifdef DEBUG
- (NSString *)descriptionWithLocale:(id)locale {

    if (![self count]) {
        return @"";
    }
    NSString *tempStr1 =
    [[self description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSPropertyListSerialization propertyListWithData:tempData
                                              options:NSPropertyListImmutable
                                               format:NULL
                                                error:NULL];
}
#endif

@end
