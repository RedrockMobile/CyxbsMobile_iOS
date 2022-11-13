//
//  UserAgreementConsentView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserAgreementConsentView;

@protocol UserAgreementConsentViewDelegate <NSObject>

- (void)userAgreementConsentView:(UserAgreementConsentView *)view selectedWithBtn:(UIButton *)btn;

@end

@interface UserAgreementConsentView : UIView

/// 代理
@property (nonatomic, weak) id <UserAgreementConsentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
