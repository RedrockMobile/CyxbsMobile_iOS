//
//  FinderView.h
//  testForLargeTitle
//
//  Created by 千千 on 2019/10/22.
//  Copyright © 2019 千千. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterButton.h"
NS_ASSUME_NONNULL_BEGIN
@class SDCycleScrollView;
@protocol LQQFinderViewDelegate <NSObject>

- (void) touchNewsSender;
- (void) touchNews;
- (void) touchWriteButton;
- (void) touchFindClass;
- (void) touchSchoolCar;
- (void) touchSchedule;
- (void) touchMore;
-(void) touchNoClassAppointment;
-(void) touchMyTest;
-(void) touchSchoolCalender;
-(void) touchMap;
-(void) touchEmptyClass;

@end

@interface FinderView : UIView
@property (nonatomic, weak) UILabel *weekTime;//当前周数
@property (nonatomic, weak) UILabel *finderTitle;//“发现”标题
@property (nonatomic, weak) UIButton *writeButton;//签到按钮
@property (nonatomic, weak) SDCycleScrollView *bannerView;//
@property (nonatomic, weak) UIButton *newsSender;//教务在线标题
@property (nonatomic, weak) UIButton *news;//教务在线具体新闻标题
@property (nonatomic, copy)NSMutableArray <EnterButton*>*enterButtonArray;//四个入口按钮
@property (nonatomic, weak)id<LQQFinderViewDelegate> delegate;
@property (nonatomic)NSMutableArray * bannerURLStrings;//轮播图urlString
-(void)remoreAllEnters;//移除四个入口
-(void)addSomeEnters;//添加四个入口
@end

NS_ASSUME_NONNULL_END
