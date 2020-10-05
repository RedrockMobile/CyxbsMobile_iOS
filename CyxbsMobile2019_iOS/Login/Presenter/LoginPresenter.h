//
//  LoginPresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LoginViewController.h"
#import "LoginModel.h"
#import "LoginViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginPresenter : NSObject

@property (nonatomic, strong) LoginViewController<LoginViewProtocol> *attachedView;
@property (nonatomic, strong) LoginModel *model;

- (void)attachView:(LoginViewController<LoginViewProtocol> *)attachedView;
- (void)detachView;

- (void)loginWithStuNum:(NSString *)stuNum andIdNum:(NSString *)idNum;

@end

NS_ASSUME_NONNULL_END
