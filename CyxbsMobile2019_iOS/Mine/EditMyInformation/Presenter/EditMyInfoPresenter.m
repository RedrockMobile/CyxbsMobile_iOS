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
            [self.attachedViwe profileUploadedSuccess];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)uploadUserInfo:(NSDictionary *)userInfo {
//    @"stuNum": [UserDefaultTool getStuNum],
//    @"idNum": [UserDefaultTool getIdNum],
//    @"nickname": self.contentView.nicknameTextField.text ? self.contentView.nicknameTextField.text : self.contentView.nicknameTextField.placeholder,
//    @"introduction": self.contentView.introductionTextField.text ? self.contentView.introductionTextField.text : self.contentView.introductionTextField.placeholder,
//    @"qq": self.contentView.QQTextField.text ? self.contentView.QQTextField.text : self.contentView.QQTextField.placeholder,
//    @"phone": self.contentView.phoneNumberTextField.text ? self.contentView.phoneNumberTextField.text : self.contentView.phoneNumberTextField.placeholder,
//    @"photo_src": [UserItemTool defaultItem].headImgUrl ? [UserItemTool defaultItem].headImgUrl : @""
    
    [UserItemTool defaultItem].nickname = userInfo[@"nickname"];
    [UserItemTool defaultItem].introduction = userInfo[@"introduction"];
    [UserItemTool defaultItem].qq = userInfo[@"qq"];
    [UserItemTool defaultItem].phone = userInfo[@"phone"];
    [UserItemTool defaultItem].headImgUrl = userInfo[@"photo_src"];

    [EditMyInfoModel uploadUserInfo:userInfo success:^(NSDictionary * _Nonnull responseObject) {
        [self.attachedViwe userInfoUploadedSuccess];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)attachView:(EditMyInfoViewController *)view {
    _attachedViwe = view;
}

- (void)dettatchView {
    _attachedViwe = nil;
}

@end
