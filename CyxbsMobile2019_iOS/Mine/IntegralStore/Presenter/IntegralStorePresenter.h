//
//  IntegralStorePresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntegralStorePresenterProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@class IntegralStoreModel;
@interface IntegralStorePresenter : NSObject

@property (nonatomic, weak) UIViewController<IntegralStorePresenterProtocol> *view;
@property (nonatomic, strong) IntegralStoreModel *model;

- (void)attachView:(UIViewController<IntegralStorePresenterProtocol> *) view;
- (void)dettachView;

- (void)loadStoreData;
- (void)buyWithName:(NSString *)name andValue:(NSString *)value;

- (void)refreshIntegralNum;

@end

NS_ASSUME_NONNULL_END
