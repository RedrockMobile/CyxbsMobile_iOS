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

@interface SSRTextCycleCell : UITableViewCell

- (instancetype)init NS_UNAVAILABLE;

/// 全frame屏Lab
@property (nonatomic, strong) UILabel *ssrTextLab;

/// 绘制，可重写
- (void)drawTextLab;

@end

NS_ASSUME_NONNULL_END