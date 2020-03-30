//
//  QADetailView.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol QADetailDelegate <NSObject>

-(void)tapPraiseBtn:(UIButton *)pariseBtn answerId:(NSNumber *)answerId;
-(void)tapAdoptBtn:(NSNumber *)answerId;
-(void)tapCommentBtn:(NSNumber *)answerId;
-(void)replyComment:(NSNumber *)answerId;
@end
@interface QADetailView : UIView
@property(strong,nonatomic)UIButton *answerButton;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(nonatomic,weak)id<QADetailDelegate>delegate;
@property(nonatomic,assign)BOOL isSelf;

-(void)setupUIwithDic:(NSDictionary *)dic answersData:(NSArray *)answersData;
@end

NS_ASSUME_NONNULL_END
