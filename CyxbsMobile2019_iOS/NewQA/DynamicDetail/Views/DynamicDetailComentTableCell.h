//
//  DynamicDetailComentTableCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicDetailCommentTableCellModel.h"

NS_ASSUME_NONNULL_BEGIN
/**评论级别*/
typedef NS_ENUM(int,DynamicCommentType) {
    ///一级
    DynamicCommentType_stair,
    ///二级
    DynamicCommentType_secondLevel
};

/**
 * 概述：
 * 一级评论和2级评论都是用的cell，根据传入的 `DynamicCommentType`标识来确定cell的UI构成是几级评论的样式
 *
 * 不同级别评论的UI构成
 *
 * 一级：初始的UI构成，不变化
 *
 * 二级：
 *
 *1.头像框右移
 *
 *2.隐藏发布时间
 *
 *3.文本内容发生变化：具体内容前先有一个 昵称 回复
 *
 */
@interface DynamicDetailComentTableCell : UITableViewCell

///cell的数据model
@property (nonatomic, strong) DynamicDetailCommentTableCellModel *dataModel;

/// 分割线
@property(nonatomic, strong) UILabel *lineLB;

/// 底部的label
@property (nonatomic, strong) UILabel *bottomLbl;

///根绝传入的type决定cell是几级评论的cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentType:(DynamicCommentType)type;
@end

NS_ASSUME_NONNULL_END
