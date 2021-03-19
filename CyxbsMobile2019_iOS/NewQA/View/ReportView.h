//
//  ReportView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ReportViewDelegate <NSObject>

- (void)ClickedSureBtn;
- (void)ClickedCancelBtn;

@end

@interface ReportView : UIView
/**举报类型model 1--评论  0-帖子*/
@property (nonatomic,assign) NSInteger model;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSNumber *postID;

@property (nonatomic, weak) id<ReportViewDelegate> delegate;
- (instancetype)initWithPostID:(NSNumber *)PostID;

@end

NS_ASSUME_NONNULL_END
