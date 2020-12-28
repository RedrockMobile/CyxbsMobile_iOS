//
//  ShareView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShareViewDelegate <NSObject>

- (void)ClickedQQZone;
- (void)ClickedVXGroup;
- (void)ClickedQQ;
- (void)ClickedVXFriend;
- (void)ClickedUrl;
- (void)ClickedCancel;

@end

@interface ShareView : UIView
///QQ空间按钮
@property (nonatomic, strong) UIButton *qqZoneBtn;
///朋友圈按钮
@property (nonatomic, strong) UIButton *VXGroupBtn;
///QQ按钮
@property (nonatomic, strong) UIButton *QQBtn;
///微信好友按钮
@property (nonatomic, strong) UIButton *VXFriendBtn;
///复制链接按钮
@property (nonatomic, strong) UIButton *UrlBtn;


@property (nonatomic, weak) id<ShareViewDelegate> delegate;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END

