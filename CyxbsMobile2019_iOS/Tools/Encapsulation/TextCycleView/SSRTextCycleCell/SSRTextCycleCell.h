//
//  SSRTextCycleCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SSRTextCycleCellReuseIdentifier @"SSRTextCycleCell"

NS_ASSUME_NONNULL_BEGIN

@class SSRTextCycleCell;

typedef void (^cellStyle)(SSRTextCycleCell *);

#pragma mark - SSRTextCycleCell

/// 文字单个Cell
@interface SSRTextCycleCell : UITableViewCell

/// 全frame屏Lab
@property (nonatomic, strong) UILabel *ssrTextLab;

/// 设置cell的style
@property (nonatomic, copy) cellStyle cellStyle;

/// 绘制，可重写
- (void)drawTextLab;

@end

NS_ASSUME_NONNULL_END
