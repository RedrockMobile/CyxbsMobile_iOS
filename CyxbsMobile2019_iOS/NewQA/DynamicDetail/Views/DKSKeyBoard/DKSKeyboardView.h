//
//  DKSKeyboardView.h
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DKSKeyboardDelegate <NSObject>

@optional //非必实现的方法


- (void)textViewContentText:(NSString *)textStr;

- (void)leftButtonClick:(NSString *)textStr;
///点击发送按钮调用的方法
- (void)rightButtonClick:(NSString *)textStr;

//让举报的view
//- (void)riseReportViewWithY:(CGFloat)y AndDictionnary:(NSDictionary *)userInfo;

@end

@interface DKSKeyboardView : UIView <UITextViewDelegate>

@property (nonatomic, weak) id <DKSKeyboardDelegate>delegate;

@property (nonatomic, strong) UITextView *textView;

/// 发送按钮
@property (nonatomic, strong) UIButton *moreBtn;

/// textView的最大高度
@property (nonatomic, assign) double maxTextViewheight;

/// TextView的旧时高度
@property (nonatomic, assign) CGFloat oldTextViewHeight;

/// 原始的textView的size
@property (nonatomic, assign) CGSize originTextViewSize;
- (void)startInputAction;
- (void)clearCurrentInput;
@end
