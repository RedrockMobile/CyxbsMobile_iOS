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

- (void)requestCheckInInfo {
    // 请求签到数据
    
    CheckInModel *checkInModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[CheckInModel archivePath]];
    if (!checkInModel || [NSDate date].weekday == 2) {
        checkInModel = [[CheckInModel alloc] init];
        checkInModel.checkInDays = @[@1, @3, @4, @5];
        checkInModel.continuallyCheckInDays = @0;
    }
    
    [self.attachedView CheckInInfoRequestSucceededWithModel:checkInModel];
}

@end
