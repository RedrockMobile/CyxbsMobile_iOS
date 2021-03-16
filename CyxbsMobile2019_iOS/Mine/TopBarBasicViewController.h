//
//  TopBarBasicViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//带有一个顶部导航条的基类

#import <UIKit/UIKit.h>
#import "NothingStateView.h"


NS_ASSUME_NONNULL_BEGIN

@interface TopBarBasicViewController : UIViewController

/// 设置这个属性自动完成顶部自定义导航条的设置
@property (nonatomic,copy)NSString *VCTitleStr;
@property (nonatomic,strong)UIView *topBarView;
@end

NS_ASSUME_NONNULL_END
