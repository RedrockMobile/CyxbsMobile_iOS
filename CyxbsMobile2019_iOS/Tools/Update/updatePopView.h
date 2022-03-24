//
//  updatePopView.h
//  CyxbsMobile2019_iOS
//
//  Created by Clutch Powers on 2022/3/22.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol updatePopViewDelegate <NSObject>

- (void) Cancel;
- (void) Update;

@end

@interface updatePopView : UIView

@property (nonatomic, strong) UIView *AlertView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, weak) id<updatePopViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame WithUpdateInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
