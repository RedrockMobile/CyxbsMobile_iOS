//
//  QABaseViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/3/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QABaseViewController : UIViewController
/// 举报按钮
@property(nonatomic,strong)UIButton *rightButton;
- (void)customNavigationBar;
- (void)customNavigationRightButton;
@end

NS_ASSUME_NONNULL_END
