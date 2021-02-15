
//  SZHHotSearchView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
展示内容： 展示热门搜索/重邮知识库，热门搜索按钮/重邮知识库按钮的界面
应用界面：搜索初始页、搜索结果页
 */
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol SZHHotSearchViewDelegate <NSObject>

@optional
/// 点击热门搜索item会调用的方法
- (void)touchHotSearchBtnsThroughBtn:(UIButton *)btn;

/// 点击重邮知识库item会调用的方法
- (void)touchCQUPTKonwledgeThroughBtn:(UIButton *)btn;
@end
@interface SZHHotSearchView : UIView
@property (nonatomic, weak) id <SZHHotSearchViewDelegate>delegate;

/// “邮问知识库”、“热门搜索的按钮”
@property (nonatomic, strong) UILabel *hotSearch_KnowledgeLabel;

///历史记录或者邮问知识库的button,可自动换行(仿造课表historyView逻辑)
//@property (nonatomic, strong) NSMutableArray <UIButton*>*buttonArray;//每一个button
@property (nonatomic, strong) NSArray *buttonTextAry;

//根据传入的字符串决定显示的是热门搜索还是知识库
- (instancetype)initWithString:(NSString *)string;
/// 更新UI
- (void)updateBtns;
@end

NS_ASSUME_NONNULL_END
