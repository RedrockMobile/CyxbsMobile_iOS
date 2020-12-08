//
//  SchoolBusPresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolBusProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SchoolBusModel;
@interface SchoolBusPresenter : NSObject

@property (nonatomic, strong) UIViewController<SchoolBusProtocol> *view;
@property (nonatomic, strong) SchoolBusModel *model;

- (void)attachView:(UIViewController<SchoolBusProtocol> *)view;
- (void)dettachView;

- (void)requestSchoolBusLocation;

@end

NS_ASSUME_NONNULL_END
