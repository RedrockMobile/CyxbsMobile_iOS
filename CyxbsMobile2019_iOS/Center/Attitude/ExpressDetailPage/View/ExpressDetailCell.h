//
//  ExpressDetailCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpressDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *checkImage;
@property (nonatomic, strong) UILabel *percent;
/// 渐变层
@property (nonatomic, strong) UIView *gradientView;

/// 选中后的第一步是恢复初始状态
- (void)backToOriginState;

/// 选中的cell的UI情况
- (void)selectCell;

/// 其他cell的UI情况
- (void)otherCell;

@end

NS_ASSUME_NONNULL_END
