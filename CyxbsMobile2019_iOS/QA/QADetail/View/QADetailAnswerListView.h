//
//  QADetailAnswerListView.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol QADetailAnswerListViewDelegate <NSObject>

- (void)tapToViewBigAnswerImage:(UIButton *)sender;
//点赞
- (void)tapPraiseBtn:(UIButton *)sender;
//采纳
- (void)tapAdoptBtn:(UIButton *)sender;
//点击某条回答后调用，answerId是某条回答的tag
- (void)tapToViewComment:(UIView *)sender;
@end
@interface QADetailAnswerListView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *adoptBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
///回答页面答题者名字下面的时间label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *tapToViewImages;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLabel;
@property (weak, nonatomic) IBOutlet UIView *separateView;
@property (weak, nonatomic) IBOutlet UIButton *tapToViewComment;
@property(strong,nonatomic)NSNumber *answerId;
- (void)setupView:(NSDictionary *)dic isSelf:(BOOL)isSelf;
@property(nonatomic,weak)id<QADetailAnswerListViewDelegate>actionDelagate;
@end

NS_ASSUME_NONNULL_END
