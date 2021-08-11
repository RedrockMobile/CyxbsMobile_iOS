//
//  IntegralStoreViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralStoreContentView.h"

NS_ASSUME_NONNULL_BEGIN

@class IntegralStorePresenter;
/// 老版积分商城
@interface IntegralStoreViewController : UIViewController

@property (nonatomic, strong) IntegralStorePresenter *presenter;
@property (nonatomic, weak) IntegralStoreContentView *contentView;

@end

NS_ASSUME_NONNULL_END
