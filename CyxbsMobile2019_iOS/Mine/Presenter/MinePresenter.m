//
//  MinePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/31.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MinePresenter.h"

@implementation MinePresenter

- (void)attachView:(UIViewController<MineContentViewProtocol> *)view {
    _attachedView = view;
}

- (void)detachView {
    _attachedView = nil;
}

- (void)requestQAInfo {
    // 请求邮问数据
    [self.attachedView QAInfoRequestsSucceeded];
}

@end
