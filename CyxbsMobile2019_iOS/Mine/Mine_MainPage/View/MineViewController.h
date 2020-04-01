//
//  MineViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineViewController : UIViewController

@property (nonatomic, weak) MineContentView *contentView;

/// 用于编辑界面的返回
@property (nullable, nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void)loadUserData;

@end

NS_ASSUME_NONNULL_END
