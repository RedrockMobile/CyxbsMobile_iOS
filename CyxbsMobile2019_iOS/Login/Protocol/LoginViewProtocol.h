//
//  LoginViewProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewProtocol <NSObject>

- (void)loginSucceeded:(UserItem *)item;
- (void)loginFailed;

@end

NS_ASSUME_NONNULL_END
