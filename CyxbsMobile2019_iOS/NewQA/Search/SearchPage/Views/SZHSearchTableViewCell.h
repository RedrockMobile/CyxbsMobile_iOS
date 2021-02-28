//
//  SZHSearchTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 展示内容：搜索历史的tablecell
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SZHSearchTableViewCellDelegate <NSObject>

/// 删除选中的cell
/// @param string cell中的string
- (void)deleteHistoryCellThroughString:(NSString *)string;

@end
@interface SZHSearchTableViewCell : UITableViewCell
/// 显示文本的cell
@property (nonatomic, strong) UILabel *textLbl;

/// 清除该条记录的按钮
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) NSString *string;
@property (nonatomic, assign) id <SZHSearchTableViewCellDelegate>delegate;

- (instancetype)initWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
