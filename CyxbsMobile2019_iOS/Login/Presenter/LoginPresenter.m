//
//  LoginPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "LoginPresenter.h"
#import "LoginViewProtocol.h"

@implementation LoginPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LoginModel alloc] init];
    }
    return self;
}

- (void)attachView:(LoginViewController<LoginViewProtocol> *)attachedView {
    _attachedView = attachedView;
}

- (void)detachView {
    _attachedView = nil;
}

- (void)loginWithStuNum:(NSString *)stuNum andIdNum:(NSString *)idNum {
    [_model loginWithStuNum:stuNum andIdNum:idNum succeeded:^(NSDictionary * _Nonnull responseObject) {
        UserItem *item = [UserItem mj_objectWithKeyValues:responseObject];
        [UserItemTool archive:item];
        [self.attachedView loginSucceeded:item];
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [self.attachedView loginFailed];
    }];
}

@end
