//
//  ScheduleTabBar.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleTabBar.h"
#import "ScheduleBottomBar.h"

#import "ScheduleTouchItem.h"

#import "ScheduleNETRequest.h"
#import "ScheduleShareCache.h"

#pragma mark - ScheduleTabBar ()

@interface ScheduleTabBar ()

@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

#pragma mark - ScheduleTabBar

@implementation ScheduleTabBar {
    CAShapeLayer *_shapeLayer;
    ScheduleBottomBar *_bottomBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _heightForScheduleBar = 58;
        [self insertSubview:self.effectView atIndex:0];
        [self addSubview:[self bottomBar]];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [super sizeThatFits:size];
    if (!self.isScheduleBarHidden) {
        sizeThatFits.height += self.heightForScheduleBar;
    }
    
    CGRect effectViewFrame = { {0, 0}, sizeThatFits };
    self.effectView.frame = effectViewFrame;
    _shapeLayer.frame = self.effectView.bounds;
    _shapeLayer.path = [self _makeBezierPath].CGPath;
    
    CGRect bottomBarFrame = { {0, 0}, {sizeThatFits.width, self.heightForScheduleBar} };
    self.bottomBar.hidden = self.isScheduleBarHidden;
    self.bottomBar.frame = bottomBarFrame;
    
    return sizeThatFits;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        CGRect frame = subview.frame;
        if (!self.scheduleBarHidden) {
            frame.origin.y += self.heightForScheduleBar;
            frame.size.height -= self.heightForScheduleBar;
        }
        subview.frame = frame;
    }
}

#pragma mark - Method

- (void)reload {
    ScheduleIdentifier *mainKey = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyMain];
    if (mainKey) {
        [ScheduleNETRequest.current
         policyKeys:@[mainKey]
         success:^(ScheduleCombineItem * _Nonnull item) {
            ScheduleTouchItem *touch = [[ScheduleTouchItem alloc] init];
            touch.combining = item;
            ScheduleCourse *now = touch.floorCourse;
            if (now) {
                self.bottomBar.title = now.course;
                self.bottomBar.time = now.timeStr;
                self.bottomBar.place = now.classRoom;
            } else {
                self.bottomBar.title = @"今天已经没课了";
                self.bottomBar.time = @"也许明天才有课";
                self.bottomBar.place = @"好好休息下";
            }
        }
         failure:^(NSError * _Nonnull error, ScheduleIdentifier * _Nonnull errorID) {
            self.bottomBar.title = @"网络请求失败";
            self.bottomBar.time = @"无法加载时间";
            self.bottomBar.place = @"无法加载地点";
        }];
    }
}

#pragma mark - Setter

- (void)setScheduleBarHidden:(BOOL)scheduleBarHidden {
    _scheduleBarHidden = scheduleBarHidden;
    CGSize sizeThatFits = [self sizeThatFits:self.bounds.size];
    CGRect bounds = { self.bounds.origin, sizeThatFits };
    self.bounds = bounds;
}

#pragma mark - Private

- (UIBezierPath *)_makeBezierPath {
    CGSize radii = (self.isScheduleBarHidden ? CGSizeMake(0, 0) : CGSizeMake(16, 16));
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.effectView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:radii];
    return bezierPath;
}

#pragma mark - Lazy

- (UIVisualEffectView *)effectView {
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.path = [self _makeBezierPath].CGPath;
        
        _effectView.layer.mask = _shapeLayer;
    }
    return _effectView;
}

- (ScheduleBottomBar *)bottomBar {
    if (_bottomBar == nil) {
        _bottomBar = [[ScheduleBottomBar alloc] init];
        _bottomBar.title = @"正在请求课程";
        _bottomBar.time = @"课程的时间";
        _bottomBar.place = @"课程的地点";
    }
    return _bottomBar;
}

@end
