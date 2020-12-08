//
//  ActivityView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityView : UIView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UILabel *activityLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *signUpTime;
@property (nonatomic, strong) UILabel *activityTime;
@property (nonatomic, strong) UILabel *activityHour;

@end

NS_ASSUME_NONNULL_END
