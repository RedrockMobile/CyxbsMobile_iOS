//
//  ScheduleDetailController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleDetailPartContext.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScheduleCustomViewControllerDelegate;

@interface ScheduleDetailController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithContexts:(NSArray <ScheduleDetailPartContext *> *)contexts;

@property (nonatomic, weak) id <ScheduleCustomViewControllerDelegate> delegateIfNeeded;

@end

NS_ASSUME_NONNULL_END
