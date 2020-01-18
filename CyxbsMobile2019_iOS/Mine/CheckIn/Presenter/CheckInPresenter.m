//
//  CheckInPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CheckInPresenter.h"
#import "CheckInModel.h"

@interface CheckInPresenter ()

@property (nonatomic, strong) CheckInModel *model;

@end

@implementation CheckInPresenter

- (void)checkIn {
    [self.model CheckInSucceeded:^{
        [self.view checkInSucceded];
    } Failed:^(NSError * _Nonnull err) {
        [self.view checkInFailed];
    }];
}


- (void)attachView:(UIViewController<CheckInProtocol> *)view {
    _model = [[CheckInModel alloc] init];
    _view = view;
}

- (void)dettachView {
    _view = nil;
}

@end
