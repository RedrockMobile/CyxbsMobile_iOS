//
//  DiscoverADModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverADModel.h"

@implementation DiscoverADModel

#pragma mark - Init

- (void)GETADsSuccess:(void (^)(void))setModel {
    // 网络请求，因为必须alloc，所以传出不需要东西
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
        
        setModel();
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"🔴AD ERROR");
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 有代理才执行
    if (self.delegate) {
        // 如果这个最开始为空，则直接出去
        if (self.discoverADs == nil) {
            return [self.delegate discoverAD:nil cellForCollectionView:collectionView];
        }
        // 同理，个数为0啥也不是
        if (self.discoverADs.ADs.count == 0) {
            return [self.delegate discoverAD:nil cellForCollectionView:collectionView];
        }
        // 第0个传最后一个，其他的按取余方式传递
        if (indexPath.item == 0) {
            return [self.delegate discoverAD:self.discoverADs.ADs[self.discoverADs.ADs.count - 1] cellForCollectionView:collectionView];
        } else {
            return [self.delegate discoverAD:self.discoverADs.ADs[(indexPath.item - 1) % self.discoverADs.ADs.count] cellForCollectionView:collectionView];
        }
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 如果没有或者个数为0，则有一个让collection显示默认，否则应该返回个数+2个，实现无限循环
    return self.discoverADs ? (self.discoverADs.ADs.count == 0 ? 1 : self.discoverADs.ADs.count + 2) : 1;
}

@end
