//
//  EditMyInfoPresneter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditMyInfoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditMyInfoPresenter : NSObject

@property (nonatomic, strong) EditMyInfoViewController *attachedViwe;

- (void)attachView: (EditMyInfoViewController *)view;
- (void)dettatchView;

@end

NS_ASSUME_NONNULL_END
