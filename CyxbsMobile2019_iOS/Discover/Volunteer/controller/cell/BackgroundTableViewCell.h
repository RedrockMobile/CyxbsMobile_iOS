//
//  BackgroundTableViewCell.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 25/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel1;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel2;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
+ (instancetype) cellWithTableView:(UITableView *)tableView;

@end
