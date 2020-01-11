//
//  CheckInPresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckInProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CheckInModel;

@interface CheckInPresenter : NSObject

@property (nonatomic, strong) UIViewController<CheckInProtocol> *view;
@property (nonatomic, strong) CheckInModel *checkInModel;

- (void)attachView:(UIViewController<CheckInProtocol> *) view;
- (void)dettachView;

@end

NS_ASSUME_NONNULL_END
