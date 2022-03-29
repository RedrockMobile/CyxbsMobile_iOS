//
//  DiscoverADModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DiscoverADModel.h"

@implementation DiscoverADModel

#pragma mark - Init

- (void)GETADsSuccess:(void (^)(DiscoverADModel *ADModel))setModel {
    
    [HttpClient.defaultClient
     requestWithPath:BANNERVIEWAPI
     method:HttpRequestGet
     parameters:nil
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"🟢AD:\n%@",responseObject);
        
        DiscoverADs *ADs = [[DiscoverADs alloc] initWithDictionary:responseObject];
        
        self.discoverADs = ADs;
        setModel(self);
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"🔴AD ERROR");
    }];
}

@end
