//
//  CheckInPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CheckInPresenter.h"
#import "CheckInModel.h"

@implementation CheckInPresenter

#pragma mark - Getter
- (CheckInModel *)checkInModel {
    if (!_checkInModel) {
        _checkInModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[CheckInModel archivePath]];
        if (!_checkInModel) {
            _checkInModel = [[CheckInModel alloc] init];
            _checkInModel.checkInDays = @[@1, @4, @5];
            _checkInModel.continuallyCheckInDays = @0;
        }
    }
    return _checkInModel;
}


- (void)attachView:(UIViewController<CheckInProtocol> *)view {
    _view = view;
}

- (void)dettachView {
    _view = nil;
}

@end
