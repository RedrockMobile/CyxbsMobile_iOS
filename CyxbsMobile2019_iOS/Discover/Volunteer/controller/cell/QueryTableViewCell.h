//
//  QueryTableViewCell.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 06/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QueryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellHourLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hoursImageView;
@property (nonatomic, strong) UIImageView *yearsImageView;
@property (nonatomic, strong) UILabel *yearsLabel;

+ (instancetype) cellWithTableView:(UITableView *)tableView;
@end
