//
//  SchoolBusModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SchoolBusModel.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation SchoolBusModel

//MD5加密
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];    //转换成utf-8
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [Mstr appendFormat:@"%02x",result[i]];
    }
    
    return Mstr;
}

static void extracted(NSError *error) {
  
}

- (void)requestSchoolBusLocation:(NSString *)url success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    timeSp = [timeSp substringToIndex:10];
    NSDictionary *parameters = @{
        @"s": [self md5:[timeSp stringByAppendingString:@".Redrock"]],
        @"t": timeSp,
        @"r": [self md5:[NSString stringWithFormat:@"%d", [timeSp intValue] + 1]]
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:url method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
        extracted(error);
    }];
}

@end
