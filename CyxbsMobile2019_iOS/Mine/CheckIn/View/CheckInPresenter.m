//
//  CheckInPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CheckInPresenter.h"

@implementation CheckInPresenter


- (void)attachView:(UIViewController<CheckInProtocol> *)view {
    _view = view;
}

- (void)dettachView {
    _view = nil;
}

@end
