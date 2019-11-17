//
//  EditMyInfoPresneter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoPresenter.h"

@implementation EditMyInfoPresenter

- (void)attachView:(EditMyInfoViewController *)view {
    _attachedViwe = view;
}

- (void)dettatchView {
    _attachedViwe = nil;
}

@end
