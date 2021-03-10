//
//  MainPageTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface MainPageTableViewCell : UITableViewCell

/// 时间label
@property (nonatomic, strong)UILabel *timeLabel;

/// 用户昵称
@property (nonatomic, strong)UILabel *nickNameLabel;

/// 赞/评论 了你的 评论/动态
@property (nonatomic, strong)UILabel *interactionInfoLabel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic,strong)UIImageView *headImgView;
@end

NS_ASSUME_NONNULL_END
