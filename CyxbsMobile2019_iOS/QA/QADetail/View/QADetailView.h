//
//  QADetailView.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//答案页

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol QADetailDelegate <NSObject>
- (void)tapPraiseBtn:(UIButton *)pariseBtn answerId:(NSNumber *)answerId;
- (void)tapAdoptBtn:(NSNumber *)answerId;
- (void)tapCommentBtn:(NSNumber *)answerId;
- (void)replyComment:(NSNumber *)answerId;
- (void)tapToViewBigImage:(NSInteger)answerIndex;
- (void)tapToViewBigAnswerImage:(NSInteger)answerIndex;
//查看评论
- (void)tapToViewComment:(NSNumber *)answerId;
///下拉刷新
- (void)reloadData;
///上拉加载
- (void)loadMoreAtPage:(NSNumber*)page;
//page由这边导入，或许拓展性会比较好

@end
@interface QADetailView : UIView<UIScrollViewDelegate>
@property(strong,nonatomic)UIButton *answerButton;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(nonatomic,weak)id<QADetailDelegate>delegate;
@property(nonatomic,assign)BOOL isSelf;
@property(strong,nonatomic)NSMutableArray *imageUrlArray;
@property(assign,nonatomic)NSInteger scrollviewHeight;

- (void)setupUIwithDic:(NSDictionary *)dic answersData:(NSArray *)answersData;


//调用代理的loadMoreAtPage方法加载更多后，由代理调用这个方法，入果请求成功isSuccessful==YES
//这里answersData的结构和setupUIwithDic:里面的answersData结构一样
- (void)loadMoreWithArray:(NSArray*) answersData ifSuccessful:(BOOL)isSuccessful;
@end

NS_ASSUME_NONNULL_END
