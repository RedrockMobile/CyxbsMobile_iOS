//
//  AliyunConfig.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AliyunConfig.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "NetworkManager.h"

@interface AliyunConfig() <HttpDNSDegradationDelegate>

@end

@implementation AliyunConfig

+ (void)setup {
    // 初始化HTTPDNS
    HttpDnsService *httpdns = [[HttpDnsService alloc] autoInit];
    // 为HTTPDNS服务设置降级机制
//    [httpdns setDelegateForDegradationFilter:HttpDnsService.sharedInstance];
    // 允许返回过期的IP
    [httpdns setExpiredIPEnabled:YES];
    
    // 打开HTTPDNS Log，线上建议关闭
#ifdef DEBUG
    // 测试环境
    [httpdns setLogEnabled:YES];
#else
    // 正式环境
    [httpdns setLogEnabled:YES];
#endif
    
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:@[
        @"redrock.cqupt.edu.cn"
    ]];
    NSDictionary *IPRankingDatasource = @{
        @"redrock.cqupt.edu.cn" : @80
    };
    // IP 优选功能，设置后会自动对IP进行测速排序，可以在调用 `-getIpByHost` 等接口时返回最优IP。
    [httpdns setIPRankingDatasource:IPRankingDatasource];
}

+ (NSString *)ipByHost:(NSString *)host {
    HttpDnsService *httpdns = HttpDnsService.sharedInstance;
    NSString *res = [httpdns getIpByHostAsyncInURLFormat:host];
    return res;
}

/*
 * 降级过滤器，您可以自己定义HTTPDNS降级机制
 */
- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName {
    NSLog(@"Enters Degradation filter.");
    // 根据HTTPDNS使用说明，存在网络代理情况下需降级为Local DNS
    if ([NetworkManager configureProxies]) {
        NSLog(@"Proxy was set. Degrade!");
        return YES;
    }
    return NO;
}


@end
