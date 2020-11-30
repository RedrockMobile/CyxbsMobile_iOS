//
//  LogOutView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/13.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LogOutViewDelegate <NSObject>

- (void)ClickedSureBtn;
- (void)ClickedCancelBtn;

@end

@interface LogOutView : UIView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *popView;

@property (nonatomic, strong) id<LogOutViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
