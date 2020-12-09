//
//  QueryTableViewCell.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 06/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "QueryTableViewCell.h"
#import "VolunteeringEventItem.h"
@implementation QueryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"status";
    QueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QueryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
        return cell;
    }
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIView *background = [[UIView alloc]initWithFrame:CGRectMake(54, 0, MAIN_SCREEN_W-54-17, 107)];
        background.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:background];

        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(54, 16, 52, 18)];
        timeImageView.image = [UIImage imageNamed:@"月日标签"];
        self.timeImageView = timeImageView;
        [self.contentView addSubview:timeImageView];
        
        UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 77, 11, 14)];
        addressImageView.image = [UIImage imageNamed:@"地点坐标"];
        self.addressImageView = addressImageView;
        [self.contentView addSubview:addressImageView];
        
        UIImageView *hoursImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_W-90, 79, 12, 12)];
        hoursImageView.image = [UIImage imageNamed:@"时长加号"];
        self.hoursImageView = hoursImageView;
        [self.contentView addSubview:hoursImageView];
        
        UILabel *cellContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 47,(260.f/375)*MAIN_SCREEN_W, 15)];
        cellContentLabel.font = [UIFont systemFontOfSize:14];
        cellContentLabel.textColor = [UIColor colorWithRed:28/255.0 green:27/255.0 blue:27/255.0 alpha:1];
        self.cellContentLabel = cellContentLabel;
        [self.contentView addSubview:cellContentLabel];
        
        UILabel *cellTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(61, 18, 50, 12)];
        cellTimeLabel.font = [UIFont systemFontOfSize:10];
        cellTimeLabel.textColor = [UIColor whiteColor];
        cellTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.cellTimeLabel = cellTimeLabel;
        [self.contentView addSubview:cellTimeLabel];
        
        UILabel *cellAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(84, 78,(190.f/375)*MAIN_SCREEN_W, 14)];
        cellAddressLabel.font = [UIFont systemFontOfSize:13];
        cellAddressLabel.textColor = [UIColor colorWithRed:28/255.0 green:27/255.0 blue:27/255.0 alpha:1];
        self.cellAddressLabel = cellAddressLabel;
        [self.contentView addSubview:cellAddressLabel];
        
        UILabel *cellTimeAddLabel = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_SCREEN_W-50, 79, 25, 14)];
        cellTimeAddLabel.text = @"小时";
        cellTimeAddLabel.textAlignment = NSTextAlignmentLeft;
        cellTimeAddLabel.textColor = [UIColor colorWithRed:255/255.0 green:120/255.0 blue:20/255.0 alpha:1];
        cellTimeAddLabel.font = [UIFont systemFontOfSize:11];;
        [self.contentView addSubview:cellTimeAddLabel];
        
        UILabel *cellHourLabel = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_SCREEN_W-73,79,25, 13)];
        cellHourLabel.font = [UIFont systemFontOfSize:12];
        cellHourLabel.textColor = [UIColor colorWithRed:255/255.0 green:120/255.0 blue:20/255.0 alpha:1];
        self.cellHourLabel = cellHourLabel;
        [self.contentView addSubview:cellHourLabel];
        
        UIView *redLine = [[UIView alloc]initWithFrame:CGRectMake(29, 0, 3, 127)];
        redLine.backgroundColor = [UIColor colorWithRed:253/255.0 green:105/255.0 blue:103/255.0 alpha:1];
        [self.contentView addSubview:redLine];
        
        UIColor *myColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        self.backgroundColor = myColor;
    
    }
    return self;
}

@end
