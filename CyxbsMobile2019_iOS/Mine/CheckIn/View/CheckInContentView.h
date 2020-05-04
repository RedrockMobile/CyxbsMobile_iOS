//
//  CheckInContentVIew.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/26.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckInBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CheckInContentViewDelegate <NSObject>

- (void)backButtonClicked;
- (void)CheckInButtonClicked:(UIButton *)sender;
- (void)myGoodsButtonTouched;
- (void)presentIntegralStore:(UIPanGestureRecognizer *)pan;

@end

@interface CheckInContentView : UIView

@property (nonatomic, weak) id<CheckInContentViewDelegate> delegate;

// views
@property (nonatomic, weak) UILabel *weekLabel;

@property (nonatomic, weak) CheckInBar *bar;
@property (nonatomic, weak) UIView *checkInView;
@property (nonatomic, weak) UIView *storeView;
@property (nonatomic, weak) UILabel *scoreLabel;


- (void)CheckInSucceded;

@end

NS_ASSUME_NONNULL_END
