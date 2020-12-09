//
//  HeaderTableViewCell.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 25/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
+ (instancetype) cellWithTableView:(UITableView *)tableView;


@end
