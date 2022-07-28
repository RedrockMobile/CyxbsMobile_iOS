//
//  IDModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/29.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDModel.h"

#define DeleteIdentity @"magipoke-identity/DeleteIdentity"

const IDModelIDType IDModelIDTypeAut = @"认证身份";
const IDModelIDType IDModelIDTypeCus = @"个性身份";


@implementation IDModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.idStr =
        self.departmentStr =
        self.positionStr =
        self.validDateStr =
        self.bgImgURLStr =
        self.idTypeStr = @"";
        int i = arc4random_uniform(255);
        self.color = RGBColor(i, 255-i, i/2, 1);
    }
    return self;
}

- (void)setValidDateStr:(NSString *)validDateStr {
    _validDateStr = [validDateStr copy];
    
    NSArray *arr = [validDateStr componentsSeparatedByString:@"-"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.M.dd";
    _gainIDTime = [formatter dateFromString:arr.firstObject].timeIntervalSince1970;
    _idInvalidTime = [formatter dateFromString:arr.lastObject].timeIntervalSince1970;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"idStr":@"id",
        @"departmentStr":@"form",
        @"positionStr":@"position",
        @"validDateStr":@"date",
        @"bgImgURLStr":@"background",
        @"idTypeStr":@"type"
        //        @"islate":@"islate"
        //        @"isshow":@"isshow"
    };
}
+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"color"];
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self mj_keyValues]];
}

+ (void)deleteIdentityWithIdentityId:(NSString *)identityId
                             success:(nonnull void (^)(void))success
                             failure:(nonnull void (^)(void))failue {
    [[HttpClient defaultClient]
     requestWithPath:[CyxbsMobileBaseURL_1 stringByAppendingString:DeleteIdentity]
     method:HttpRequestPost
     parameters:@{@"identityId":identityId}
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        success();
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        failue();
    }];
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}

@end

