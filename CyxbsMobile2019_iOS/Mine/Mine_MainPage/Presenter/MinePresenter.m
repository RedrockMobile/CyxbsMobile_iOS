//
//  MinePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/31.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MinePresenter.h"
#import "MineQADataItem.h"
#import "MineModel.h"

@implementation MinePresenter

- (void)attachView:(UIViewController<MineContentViewProtocol> *)view {
    _attachedView = view;
}

- (void)detachView {
    _attachedView = nil;
}

- (void)requestQAInfo {
    [MineModel requestQADataSucceeded:^(MineQADataItem * _Nonnull responseItem) {        
        [self.attachedView QAInfoRequestsSucceededWithItem:responseItem];
    } failed:^(NSError * _Nonnull err) {
        
    }];
}

@end
