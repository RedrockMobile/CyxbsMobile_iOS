//
//  PostTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionBtn.h"
#import "FuncView.h"
#import "PostItem.h"
#import "MGDClickParams.h"
#import "NewQAPostDetailLabel.h"
#import "PostTableViewCellFrame.h"
#import "NewQACellCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@class PostTableViewCell;
@protocol PostTableViewCellDelegate <NSObject>

- (void)ClickedFuncBtn:(PostTableViewCell *)cell;
- (void)ClickedStarBtn:(PostTableViewCell *)cell;
- (void)ClickedCommentBtn:(PostTableViewCell *)cell;
- (void)ClickedShareBtn:(PostTableViewCell *)cell;
- (void)ClickedGroupTopicBtn:(PostTableViewCell *)cell;

@end

@interface PostTableViewCell : UITableViewCell
///头像
@property (nonatomic, strong) UIImageView *iconImageView;
///昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
///时间
@property (nonatomic, strong) UILabel *timeLabel;
///举报，屏蔽等多功能按钮
@property (nonatomic, strong) UIButton *funcBtn;
///内容
@property (nonatomic, strong) NewQAPostDetailLabel *detailLabel;
///图片列表
@property (nonatomic, strong) NewQACellCollectionView *collectView;
///圈子标签
@property (nonatomic, strong) UIButton *groupLabel;
///点赞
@property (nonatomic, strong) FunctionBtn *starBtn;
///评论
@property (nonatomic, strong) FunctionBtn *commendBtn;
///分享
@property (nonatomic, strong) UIButton *shareBtn;
///圈子标签的背景图片
@property (nonatomic, strong) UIImage *groupImage;
///个人身份标识
@property (nonatomic, strong) UIImageView *IdentifyBackImage;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) NSNumber *tableTag;

@property (nonatomic, strong) PostItem *item;

@property (nonatomic, strong) PostTableViewCellFrame *cellFrame;

-(void)reloadCellView;

@property (nonatomic, weak) id <PostTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END


