//
//  SegmentedPageView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SegmentedPageView;

@protocol SegmentedPageViewDelegate <NSObject>

- (void)segmentedPageView:(SegmentedPageView*)view didChangeIndexFrom:(NSInteger)oldIndex;

@end
// 分页 view
@interface SegmentedPageView : UIView

/// 各顶部按钮的名字
@property (nonatomic, copy)NSArray <NSString*>*viewNameArr;

/// 顶部第一个按钮的中心与左侧的距离
@property (nonatomic, assign)CGFloat gap;

/// 当前显示的页面的下标，从0开始
@property (nonatomic, assign, readonly)NSInteger index;

/// 按钮底部小蓝条的宽度
@property (nonatomic, assign)CGFloat tipViewWidth;

@property (nonatomic, weak)id <SegmentedPageViewDelegate>delegate;

- (void)moveToPageOfIndex:(NSInteger)index animated:(BOOL)is completion:(nullable void(^)(void))callBack;
/// 配置好上面的属性后，由外界调用
- (void)reLoadUI;

/// 往某一个页面添加控件的方法之一，在block里面参照pageView进行布局，pageView是对应下标的那个页面的view，
- (void)addSubview:(UIView *)view atIndex:(NSInteger)index layout:(void(^)(UIView* pageView))layoutCode;

/// 往某一个页面添加控件的方法之二，参照返回的view进行布局，它是对应下标的那个页面的view，
- (UIView*)addSubview:(UIView *)view atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END


/*
 用法示例：
 SegmentedPageView *view = [[SegmentedPageView alloc] init];
 [self.view addSubview:view];
 
 view.viewNameArr = @[@"认证身份", @"个性身份"];
 view.gap = 0.288*SCREEN_WIDTH;
 view.tipViewWidth = 0.1653333333*SCREEN_WIDTH;
 [view mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.right.bottom.equalTo(self.view);
     make.top.equalTo(self.idDisplayView.mas_bottom).offset(0.03325123153*SCREEN_HEIGHT);
 }];
 [view reLoadUI];
 
 //添加子控件：
 UIView *subview = [[UIView alloc]init];
 [view addSubview:subview atIndex:0 layout:^(UIView * _Nonnull pageView) {
 //在这个block里面参照pageView进行布局，pageView是对应下标的那个页面的view，
 //大小和SegmentedPageView内部的scrollView一样大，
 
     [subview mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(pageView).offset(0.04433497537*SCREEN_HEIGHT);
         make.left.equalTo(pageView).offset(0.04266666667*SCREEN_WIDTH);
         make.bottom.equalTo(pageView);
         make.right.equalTo(pageView).offset(-0.04266666667*SCREEN_WIDTH);
     }];
 }];
 */
