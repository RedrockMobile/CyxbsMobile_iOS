//
//  NewQABackgroundView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NewQATopView;
@class NewQARecommendTableView;
@class NewQAFocusTableView;

@interface NewQABackgroundView : UIView

@property (nonatomic, strong) NewQATopView *topView;
@property (nonatomic, strong) NewQARecommendTableView *recommendView;
@property (nonatomic, strong) NewQAFocusTableView *focusView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
