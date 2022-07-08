//
//  BaseTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseTableViewCell;
@protocol BaseTableViewCellDelegate <NSObject>

/// 右侧按钮被点击
- (void)tableViewCell:(UITableViewCell *)cell
              Clicked:(UIButton *)sender;

@end

@interface BaseTableViewCell : UITableViewCell

/// 名称
@property (nonatomic, strong) UILabel * nameLabel;
/// 个性签名
@property (nonatomic, strong) UILabel * bioLabel;
/// 左侧的头像
@property (nonatomic, strong) UIImageView * avatarImgView;
///关注按钮
@property (nonatomic, strong) UIButton *followBtn;
///是否回关
@property (nonatomic, copy) NSString *isbefocus;

@property (nonatomic, weak) id <BaseTableViewCellDelegate> delegate;

/// 复用标识
+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
