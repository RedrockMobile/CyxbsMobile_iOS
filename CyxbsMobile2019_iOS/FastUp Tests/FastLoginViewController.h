//
//  FastLoginViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/25.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SchedulePresenter, FastLoginViewController, ScheduleIdentifier;

@protocol FastLoginViewControllerDelegate <NSObject>

@optional

- (void)viewControllerTapBegin:(FastLoginViewController *)vc;

@end

@interface FastLoginViewController : UIViewController

@property (nonatomic, weak) id <FastLoginViewControllerDelegate> delegate;

/// <#description#>
@property (nonatomic) SchedulePresenter *presenter;

@property (nonatomic, strong, nullable) ScheduleIdentifier *mainID;
@property (nonatomic, strong, nullable) ScheduleIdentifier *otherID;

@end

NS_ASSUME_NONNULL_END
