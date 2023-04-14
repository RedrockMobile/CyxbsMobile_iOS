//
//  ScheduleWebHppleViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleShareCache.h"

NS_ASSUME_NONNULL_BEGIN

@class ScheduleWebHppleViewController, ScheduleCombineItem, ScheduleIdentifier;

/* MARK: - <ScheduleWebHppleViewControllerDelegate>
 * 代理将不会主动dismiss，对于hpple，会主动进行磁盘存储
 * 如果设置了name，那么对应ScheduleWidgetCache也将存储
 */

@protocol ScheduleWebHppleViewControllerDelegate <NSObject>

@optional

- (void)viewController:(ScheduleWebHppleViewController *)viewController didHppleItem:(ScheduleCombineItem *)item;

- (void)viewController:(ScheduleWebHppleViewController *)viewController dismissError:(NSString *)errorMsg;

@end

#pragma mark - ScheduleWebHppleViewController

@interface ScheduleWebHppleViewController : UIViewController

@property (nonatomic, weak) id <ScheduleWebHppleViewControllerDelegate> delegate;

- (instancetype)initWithKey:(nonnull ScheduleIdentifier *)key forName:(nullable ScheduleWidgetCacheKeyName)name;

@property (nonatomic, readonly) ScheduleIdentifier *key;
@property (nonatomic, readonly, nullable) ScheduleWidgetCacheKeyName name;

@end

NS_ASSUME_NONNULL_END
