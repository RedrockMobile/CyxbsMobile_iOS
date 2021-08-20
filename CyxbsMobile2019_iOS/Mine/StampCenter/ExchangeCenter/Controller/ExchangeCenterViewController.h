//
//  ExchangeCenterViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
//Views
#import "TopView.h"
#import "ContentScrollView.h"
#import "BottomView.h"
#import "PopupView.h"
#import "Goods.h"

NS_ASSUME_NONNULL_BEGIN
/* *
 * 商品兑换页面
 * 界面顶部一个自定义UINavigationBar - “TopView” 标题、返回按钮
 *中部一个ScrollView - “ContentScrollView” 展示商品
 *底部一个UIView - “BottomView” 用于查看价格、余额、兑换按钮
 * */
@interface ExchangeCenterViewController : UIViewController


///弹窗页面
@property (nonatomic, strong) PopupView *popupView;
///内容框
@property (nonatomic, strong) ContentScrollView *contentView;
///顶部
@property (nonatomic, strong) TopView *topView;
///底部
@property (nonatomic, strong) BottomView *bottomView;
///数据字典
@property (nonatomic, copy) NSDictionary *goodsDict;
///id
@property (nonatomic,copy) NSString *goodsID;
///计时器
@property (nonatomic) NSTimer *timer;
///滑动方向
@property (nonatomic, assign) int isDirect;
///传商品ID
- (instancetype)initWithID:(NSString *)ID;


@end

NS_ASSUME_NONNULL_END
