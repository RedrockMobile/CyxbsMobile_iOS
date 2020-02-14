//
//  MineQAPresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineQAProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineQAPresenter : NSObject

@property (nonatomic, strong) UIViewController<MineQAProtocol> *view;

- (void)attachView:(UIViewController<MineQAProtocol> *)view;
- (void)dettachView;

@end

NS_ASSUME_NONNULL_END
