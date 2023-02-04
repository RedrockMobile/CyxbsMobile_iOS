//
//  TitleView.h
//  UITextView高度自适应Demo
//
//  Created by 石子涵 on 2021/9/16.
//

#import <UIKit/UIKit.h>
#import "TodoDataModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ToDoDetailTitleViewDelegate <NSObject>

/// 改变状态
- (void)changeStatu;

///已完成状态下点击更改无效
- (void)changeInvaliePrompt;

@end

/**
 该view是用于存放todo标题的view，拥有一个状态btn和一个可编辑的titleTextView
 */
@interface ToDoDetailTitleView : UIView
/// titleView本身的size
@property (nonatomic, assign) CGSize titleViewSize;

/// textView的placeHolder
@property (nonatomic, strong) UILabel *placeHolderLbl;

/// 最前端的圆环button
@property (nonatomic, strong) UIButton *cycleBtn;

/// 文本的TextView
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) TodoDataModel *model;

@property (nonatomic, weak) id<ToDoDetailTitleViewDelegate> delegate;

///用于在外界改变该View的高的的block
@property (nonatomic, copy) void(^changeTitleViewHeightBlock)(CGFloat height);
@end

NS_ASSUME_NONNULL_END
