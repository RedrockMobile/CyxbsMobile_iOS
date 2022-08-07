//
//  AlertView.h
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/8/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol rightButtonTouchDelegate <NSObject>

-(void)rightButtonTouchedDelegateWithBtn:(UIButton *)btn;

@end

@interface AlertView : UIView

@property (nonatomic, weak) id <rightButtonTouchDelegate>delegate;

- (instancetype)initWithTitle:(NSString *)titleString AndHintTitle:(NSString *)hintString;

@end

NS_ASSUME_NONNULL_END
