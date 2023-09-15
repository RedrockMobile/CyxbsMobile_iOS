//
//  ReduceAFSecurityPolicy.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ReduceAFSecurityPolicy.h"

@implementation ReduceAFSecurityPolicy

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust forDomain:(NSString *)domain {
    // 将 IP 地址替换为域名
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:domain];
    NSString *newHost = components.host;
    
    // 创建新的 NSURL 对象
    NSURL *newURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", components.scheme, newHost]];
    
    // 调用父类的 evaluateServerTrust:forDomain: 方法进行证书校验
    BOOL originalResult = [super evaluateServerTrust:serverTrust forDomain:newURL.host];
    
    // 在原有结果的基础上，针对 "domain 不匹配" 进行额外处理
    if (!originalResult) {
        NSLog(@"domain 不匹配");
    }
    
    return originalResult;
}


@end
