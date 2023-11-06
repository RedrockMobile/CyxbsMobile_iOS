//
//  AliyunConfig.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AliyunConfig.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

static HttpDnsService *httpdns = nil;

@implementation AliyunConfig

+ (NSString *)ipByHost:(NSString *)host {
    NSString *res = [[AliyunConfig getHttpDNS] getIpByHostAsyncInURLFormat:host];
    return res;
}

+ (HttpDnsService *)getHttpDNS {
    if (httpdns == nil) {
        httpdns = [[HttpDnsService alloc] autoInit];
#if DEBUG
        [httpdns setLogEnabled:YES];
#endif
        [httpdns setExpiredIPEnabled:YES];
        [httpdns setPreResolveHosts:@[
            @"redrock.cqupt.edu.cn"
        ]];
    }
    return httpdns;
}

@end
