//
//  NotSetVolunteerButton.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotSetVolunteerButton : UIButton
@property (nonatomic, weak) UILabel *volunteerTitle;
@property (nonatomic, weak) UILabel *hintLabel;//"还没有绑定志愿者账号哦～"
@property (nonatomic, weak) UILabel *allTime;//总共时长
@property (nonatomic, weak) UILabel *shi;//“时”
@property (nonatomic, weak) UIImageView *allTimeBackImage;
@end

NS_ASSUME_NONNULL_END
