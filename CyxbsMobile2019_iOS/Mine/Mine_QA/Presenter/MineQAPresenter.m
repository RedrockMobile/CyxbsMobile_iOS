//
//  MineQAPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAPresenter.h"

@implementation MineQAPresenter

- (void)attachView:(UIViewController<MineQAProtocol> *)view {
    self.view = view;
}

- (void)dettachView {
    _view = nil;
}

@end
