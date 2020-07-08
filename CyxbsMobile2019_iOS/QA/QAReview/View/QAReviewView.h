//
//  QAReviewView.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol QAReviewDelegate <NSObject>
- (void)tapPraiseBtn:(UIButton *)pariseBtn answerId:(NSNumber *)answerId;
- (void)replyComment:(NSString *)content answerId:(NSNumber *)answerId;
@end
@interface QAReviewView : UIView <UITextFieldDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(nonatomic,weak)id<QAReviewDelegate>delegate;
@property(nonatomic,assign)BOOL isSelf;
@property(nonatomic,strong)NSNumber *answerId;
//底下的评论条
@property(strong,nonatomic)UIView *reviewBar;
@property(strong,nonatomic)UIButton *praiseBtn;
@property(strong,nonatomic)UITextField *replyTextField;
- (void)setupUIwithDic:(NSDictionary *)dic reviewData:(NSArray *)reviewData;
@end

NS_ASSUME_NONNULL_END
