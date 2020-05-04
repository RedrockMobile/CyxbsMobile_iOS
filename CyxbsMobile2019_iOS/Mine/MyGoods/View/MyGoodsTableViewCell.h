//
//  MyGoodsTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/3.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGoodsTableViewCell : UITableViewCell

@property (nonatomic, weak) UIImageView *photoImageView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UIImageView *integralImageView;

@property (nonatomic, weak) UILabel *integralLabel;

@property (nonatomic, weak) UILabel *numLabel;

@end

NS_ASSUME_NONNULL_END
