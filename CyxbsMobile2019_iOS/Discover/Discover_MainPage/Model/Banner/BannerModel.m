//
//  BannerModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel
- (void)fetchData {
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:BANNERVIEWAPI method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        BannerData *data = [[BannerData alloc]initWithDictionary:responseObject];
        self.bannerData = data;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"bannerView请求错误");
    }];
}
@end
