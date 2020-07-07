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
- (void)replyComment:(NSNumber *)answerId;
@end
@interface QAReviewView : UIView
@property(strong,nonatomic)UIScrollView *scrollView;
@property(nonatomic,weak)id<QAReviewDelegate>delegate;
@property(nonatomic,assign)BOOL isSelf;
@property(strong,nonatomic)NSMutableArray *imageUrlArray;
//底下的评论条
@property(strong,nonatomic)UIView *reviewBar;
@property(strong,nonatomic)UIButton *praiseBtn;
- (void)setupUIwithDic:(NSDictionary *)dic reviewData:(NSArray *)reviewData;
@end

NS_ASSUME_NONNULL_END
