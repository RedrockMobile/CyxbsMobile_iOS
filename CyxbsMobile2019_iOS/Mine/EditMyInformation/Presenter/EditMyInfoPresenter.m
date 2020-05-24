//
//  EditMyInfoPresneter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoPresenter.h"
#import "EditMyInfoModel.h"

@implementation EditMyInfoPresenter

- (void)uploadProfile:(UIImage *)profile {
    
    [EditMyInfoModel uploadProfile:profile success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            [UserItemTool defaultItem].headImgUrl = responseObject[@"data"][@"photosrc"];
            [self.attachedView profileUploadSuccess];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.attachedView userInfoOrProfileUploadFailure];
    }];
    
}

- (void)uploadUserInfo:(NSDictionary *)userInfo {
    [UserItemTool defaultItem].nickname = userInfo[@"nickname"];
    [UserItemTool defaultItem].introduction = userInfo[@"introduction"];
    [UserItemTool defaultItem].qq = userInfo[@"qq"];
    [UserItemTool defaultItem].phone = userInfo[@"phone"];
    [UserItemTool defaultItem].headImgUrl = userInfo[@"photo_src"];

    [EditMyInfoModel uploadUserInfo:userInfo success:^(NSDictionary * _Nonnull responseObject) {
        [self.attachedView userInfoUploadSuccess];
    } failure:^(NSError * _Nonnull error) {
        [self.attachedView userInfoOrProfileUploadFailure];
    }];
}

- (void)attachView:(EditMyInfoViewController *)view {
    _attachedView = view;
}

- (void)dettatchView {
    _attachedView = nil;
}

@end
