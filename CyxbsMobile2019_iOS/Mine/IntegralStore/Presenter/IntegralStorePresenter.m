//
//  IntegralStorePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStorePresenter.h"
#import "IntegralStoreModel.h"
#import "IntegralStoreDataItem.h"

@implementation IntegralStorePresenter

- (void)attachView:(UIViewController<IntegralStorePresenterProtocol> *)view {
    _model = [[IntegralStoreModel alloc] init];
    self.view = view;
}

- (void)dettachView {
    _view = nil;
}

- (void)loadStoreData {
    [self.model loadStoreDataSucceeded:^(NSDictionary * _Nonnull responseObject) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSDictionary *data in responseObject) {
            IntegralStoreDataItem *item = [[IntegralStoreDataItem alloc] initWithDict:data];
            [tmp addObject:item];
        }
        [self.view storeDataLoadSucceeded:tmp];
    } failed:^{
        [self.view storeDataLoadFailed];
    }];
}

- (void)buyWithName:(NSString *)name andValue:(NSString *)value {
    [self.model buyWithName:name andValue:value Succeeded:^{
        [self.view goodsOrderSuccess];
    } failed:^{
        [self.view goodsOrderFailuer];
    }];
}

- (void)refreshIntegralNum {
    [self.model refreshIntegralSucceeded:^{
        [self.view integralFreshSuccess];
    } failed:^{
        
    }];
}

@end
