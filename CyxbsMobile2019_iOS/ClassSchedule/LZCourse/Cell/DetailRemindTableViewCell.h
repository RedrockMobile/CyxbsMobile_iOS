//
//  DetailRemindTableViewCell.h
//  Demo
//
//  Created by 李展 on 2016/12/2.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailRemindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *straightLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clockImageView;
@property (weak, nonatomic) IBOutlet UIView *stackView;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIImageView *editView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end
