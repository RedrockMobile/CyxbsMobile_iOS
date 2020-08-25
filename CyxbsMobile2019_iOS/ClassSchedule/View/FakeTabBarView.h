//
//  FakeTabBarView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/25.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FakeTabBarView : UIView

/// 当前课程名称
@property (nonatomic, weak) UILabel *classLabel;

/// 时钟图片
@property (nonatomic, weak) UIImageView *clockImageView;

/// 当前课程时段
@property (nonatomic, weak) UILabel *classTimeLabel;

/// 教室地点图片
@property (nonatomic, weak) UIImageView *locationImageView;

/// 教室地点
@property (nonatomic, weak) UILabel *classroomLabel;
- (void)updateSchedulTabBarViewWithDic:(NSDictionary *)paramDict;
@end

NS_ASSUME_NONNULL_END
