//
//  FinderView.h
//  testForLargeTitle
//
//  Created by 千千 on 2019/10/22.
//  Copyright © 2019 千千. All rights reserved.
//

// 此类为发现页的基础View，包括一系列跳转按钮，轮播图在内

#import <UIKit/UIKit.h>
#import "EnterButton.h"
NS_ASSUME_NONNULL_BEGIN

@class SDCycleScrollView;
@protocol LQQFinderViewDelegate <NSObject>

- (void)touchWriteButton;
- (void)touchSchoolCar;
- (void)touchSchedule;
- (void)touchMore;
- (void)touchNoClassAppointment;
- (void)touchSchoolCalender;
- (void)touchMap;
- (void)touchToDOList; //点击邮子清单

@end

#pragma mark - FinderView

@interface FinderView : UIView

@property (nonatomic, weak) SDCycleScrollView *bannerView;//

@property (nonatomic, copy) NSMutableArray <EnterButton *> *enterButtonArray;//四个入口按钮

@property (nonatomic, weak) id<LQQFinderViewDelegate> delegate;

@property (nonatomic) NSMutableArray *bannerURLStrings;//轮播图urlString

@property (nonatomic) NSMutableArray *bannerGoToURL;//轮播图目标网页url

/// 应该在addChildViewController掉用这个 / Remake by SSR
- (UIViewController *)jwzxViewController;

- (UIViewController *)msgViewController;

- (void)remoreAllEnters;//移除四个入口
 
- (void)addSomeEnters;//添加四个入口
 
- (void)updateBannerViewIfNeeded;//在需要的时候更新bannerView

@end

NS_ASSUME_NONNULL_END
