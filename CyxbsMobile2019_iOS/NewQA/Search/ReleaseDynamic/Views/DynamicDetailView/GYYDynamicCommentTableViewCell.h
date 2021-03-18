//
//  GYYDynamicCommentTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYYDynamicCommentModel.h"
#import "FunctionBtn.h"
#import "FuncView.h"
#import "PostItem.h"

/**评论级别*/
typedef NS_ENUM(NSInteger,DynamicCommentType) {
    DynamicCommentType_stair,//一级
    DynamicCommentType_secondLevel//二级
};

NS_ASSUME_NONNULL_BEGIN

@interface GYYDynamicCommentTableViewCell : UITableViewCell
///头像
@property (nonatomic, strong) UIImageView *iconImageView;
///昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
///时间
@property (nonatomic, strong) UILabel *timeLabel;
///内容
@property (nonatomic, strong) UILabel *detailLabel;
///图片列表
@property (nonatomic, strong) UICollectionView *collectView;
///圈子标签
//@property (nonatomic, strong) UIButton *groupLabel;
///点赞
@property (nonatomic, strong) FunctionBtn *starBtn;

@property(nonatomic, strong) GYYDynamicCommentModel *commentModle;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentType:(DynamicCommentType)type;

@end



@protocol GYYDynamicCommentViewDelegate <NSObject>
/// 添加图片
- (void)addPhotos;

@end

@interface GYYDynamicCommentView : UIView
/// 代理
@property (nonatomic, weak) id<GYYDynamicCommentViewDelegate> delegate;

/// 发布动态文本内容输入框
@property (nonatomic, strong) UITextView *releaseTextView;

//显示字数的label
@property (nonatomic, strong) UILabel *numberOfTextLbl;

/// 提示文字
@property (nonatomic, strong) UILabel *placeHolderLabel;

/// 发布动态的按钮
@property (nonatomic, strong) UIButton *releaseBtn;

/// 添加图片按钮
@property (nonatomic, strong) UIButton *addPhotosBtn;
@end

NS_ASSUME_NONNULL_END
