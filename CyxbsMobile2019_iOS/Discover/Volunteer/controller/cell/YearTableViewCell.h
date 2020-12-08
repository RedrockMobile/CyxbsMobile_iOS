//
//  YearTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YearTableViewCellDelegate <NSObject>

- (void)yearChooseBtnClicked;

@end

@interface YearTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, weak) id<YearTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
