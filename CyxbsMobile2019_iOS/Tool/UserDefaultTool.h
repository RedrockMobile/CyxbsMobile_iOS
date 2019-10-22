//
//  UserDefaultTool.h
//  MoblieCQUPT_iOS
//
//  Created by 李展 on 2017/8/11.
//  Copyright © 2017年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultTool : NSObject
+(void)saveValue:(id) value forKey:(NSString *)key;

+(id)valueWithKey:(NSString *)key;

+(BOOL)boolValueWithKey:(NSString *)key;

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+(void)saveParameter:(NSDictionary *)paramterDic;

+(void)print;

+(NSString *)getStuNum;

+(NSString *)getIdNum;

+(void)removeALLData;
@end
