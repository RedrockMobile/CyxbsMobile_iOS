//
//  DeviceUtils.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/5/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DeviceUtils.h"
#import <sys/utsname.h>
static DeviceUtils* __deviceUtilsOne;
static DeviceType DeviceUtilsType;

@implementation DeviceUtils
+(void)load {
    DeviceUtilsType = 0;
    __deviceUtilsOne = [[super alloc] init];
}

+ (instancetype)alloc {
    if (__deviceUtilsOne==nil) {
        __deviceUtilsOne = [super alloc];
    }
    return __deviceUtilsOne;
}

+ (DeviceType)deviceType {
    return DeviceUtilsType;
}

DeviceType getDeviceType(void){
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                           encoding:NSUTF8StringEncoding];
    
    //simulator
    if ([platform isEqualToString:@"i386"])          return Simulator;
    if ([platform isEqualToString:@"x86_64"])        return Simulator;

    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return IPhone_1G;
    if ([platform isEqualToString:@"iPhone1,2"])     return IPhone_3G;
    if ([platform isEqualToString:@"iPhone2,1"])     return IPhone_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])     return IPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"])     return IPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"])     return IPhone_4s;
    if ([platform isEqualToString:@"iPhone5,1"])     return IPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"])     return IPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"])     return IPhone_5C;
    if ([platform isEqualToString:@"iPhone5,4"])     return IPhone_5C;
    if ([platform isEqualToString:@"iPhone6,1"])     return IPhone_5S;
    if ([platform isEqualToString:@"iPhone6,2"])     return IPhone_5S;
    if ([platform isEqualToString:@"iPhone7,1"])     return IPhone_6P;
    if ([platform isEqualToString:@"iPhone7,2"])     return IPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"])     return IPhone_6s;
    if ([platform isEqualToString:@"iPhone8,2"])     return IPhone_6s_P;
    if ([platform isEqualToString:@"iPhone8,4"])     return IPhone_SE;
    if ([platform isEqualToString:@"iPhone9,1"])     return IPhone_7;
    if ([platform isEqualToString:@"iPhone9,3"])     return IPhone_7;
    if ([platform isEqualToString:@"iPhone9,2"])     return IPhone_7P;
    if ([platform isEqualToString:@"iPhone9,4"])     return IPhone_7P;
    if ([platform isEqualToString:@"iPhone10,1"])    return IPhone_8;
    if ([platform isEqualToString:@"iPhone10,4"])    return IPhone_8;
    if ([platform isEqualToString:@"iPhone10,2"])    return IPhone_8P;
    if ([platform isEqualToString:@"iPhone10,5"])    return IPhone_8P;
    if ([platform isEqualToString:@"iPhone10,3"])    return IPhone_X;
    if ([platform isEqualToString:@"iPhone10,6"])    return IPhone_X;
    if ([platform isEqualToString:@"iPhone11,8"])    return iPhone_XR;
    if ([platform isEqualToString:@"iPhone11,2"])    return iPhone_XS;
    if ([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"])  return iPhone_XS_Max;

    return Unknown;
   
}
@end

/*
 + (DeviceType)deviceType{
     struct utsname systemInfo;
     uname(&systemInfo);
     NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
     
     //simulator
     if ([platform isEqualToString:@"i386"])          return Simulator;
     if ([platform isEqualToString:@"x86_64"])        return Simulator;

     //iPhone
     if ([platform isEqualToString:@"iPhone1,1"])     return IPhone_1G;
     if ([platform isEqualToString:@"iPhone1,2"])     return IPhone_3G;
     if ([platform isEqualToString:@"iPhone2,1"])     return IPhone_3GS;
     if ([platform isEqualToString:@"iPhone3,1"])     return IPhone_4;
     if ([platform isEqualToString:@"iPhone3,2"])     return IPhone_4;
     if ([platform isEqualToString:@"iPhone4,1"])     return IPhone_4s;
     if ([platform isEqualToString:@"iPhone5,1"])     return IPhone_5;
     if ([platform isEqualToString:@"iPhone5,2"])     return IPhone_5;
     if ([platform isEqualToString:@"iPhone5,3"])     return IPhone_5C;
     if ([platform isEqualToString:@"iPhone5,4"])     return IPhone_5C;
     if ([platform isEqualToString:@"iPhone6,1"])     return IPhone_5S;
     if ([platform isEqualToString:@"iPhone6,2"])     return IPhone_5S;
     if ([platform isEqualToString:@"iPhone7,1"])     return IPhone_6P;
     if ([platform isEqualToString:@"iPhone7,2"])     return IPhone_6;
     if ([platform isEqualToString:@"iPhone8,1"])     return IPhone_6s;
     if ([platform isEqualToString:@"iPhone8,2"])     return IPhone_6s_P;
     if ([platform isEqualToString:@"iPhone8,4"])     return IPhone_SE;
     if ([platform isEqualToString:@"iPhone9,1"])     return IPhone_7;
     if ([platform isEqualToString:@"iPhone9,3"])     return IPhone_7;
     if ([platform isEqualToString:@"iPhone9,2"])     return IPhone_7P;
     if ([platform isEqualToString:@"iPhone9,4"])     return IPhone_7P;
     if ([platform isEqualToString:@"iPhone10,1"])    return IPhone_8;
     if ([platform isEqualToString:@"iPhone10,4"])    return IPhone_8;
     if ([platform isEqualToString:@"iPhone10,2"])    return IPhone_8P;
     if ([platform isEqualToString:@"iPhone10,5"])    return IPhone_8P;
     if ([platform isEqualToString:@"iPhone10,3"])    return IPhone_X;
     if ([platform isEqualToString:@"iPhone10,6"])    return IPhone_X;
     if ([platform isEqualToString:@"iPhone11,8"])    return iPhone_XR;
     if ([platform isEqualToString:@"iPhone11,2"])    return iPhone_XS;
     if ([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"])  return iPhone_XS_Max;

     return Unknown;
    
 }
 */
