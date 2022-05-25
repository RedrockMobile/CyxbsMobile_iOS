//
//  NewDownloadCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define NewDownloadCellReuseIdentifier @"NewDownloadCell"

@class NewDownloadCell;

#pragma mark - NewDownloadCellDelegate

@protocol NewDownloadCellDelegate <NSObject>

@required

/// 单击了哪一个index
/// @param cell 当前cell
/// @param index 当前行
- (void)newDownloadCell:(NewDownloadCell *)cell shouldDownLoadAtIndex:(NSInteger)index;

@end

@interface NewDownloadCell : UITableViewCell

@property (nonatomic, weak) id <NewDownloadCellDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

/// 根据文字直接布局
/// @param title 下载的项目名字
- (void)drawWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
