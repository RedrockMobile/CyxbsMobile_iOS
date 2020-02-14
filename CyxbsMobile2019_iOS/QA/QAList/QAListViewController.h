//
//  QAListViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAListViewController : UIViewController
@property (strong, nonatomic) UIViewController *superController;
- (instancetype)initViewStyle:(NSString *)style;
@end

NS_ASSUME_NONNULL_END
