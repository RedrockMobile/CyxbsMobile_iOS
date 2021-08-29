//
//  TopView.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///顶部View
@interface TopView : UINavigationBar

///是否是装扮
@property (nonatomic, assign) bool isDress;
///返回按钮
@property (nonatomic, strong) UIButton *backBtn;
///返回按钮
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
