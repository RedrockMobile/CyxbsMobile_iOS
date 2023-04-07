//
//  ScheduleWebHppleViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScheduleWebHppleViewController, ScheduleCombineItem;

#pragma mark - <ScheduleWebHppleViewControllerDelegate>

@protocol ScheduleWebHppleViewControllerDelegate <NSObject>

@optional

- (void)viewController:(ScheduleWebHppleViewController *)viewController didHppleItem:(ScheduleCombineItem *)item;

- (void)viewController:(ScheduleWebHppleViewController *)viewController dismissError:(NSString *)errorMsg;

@end

#pragma mark - ScheduleWebHppleViewController

@interface ScheduleWebHppleViewController : UIViewController

@property (nonatomic, copy) NSString *sno;

@property (nonatomic, weak) id <ScheduleWebHppleViewControllerDelegate> delegate;

- (instancetype)initWithSno:(NSString *)sno;

@end

NS_ASSUME_NONNULL_END
