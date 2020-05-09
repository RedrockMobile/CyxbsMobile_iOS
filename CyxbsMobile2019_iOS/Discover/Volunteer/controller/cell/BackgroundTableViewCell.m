//
//  BackgroundTableViewCell.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 25/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "BackgroundTableViewCell.h"

@implementation BackgroundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"status";
    BackgroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BackgroundTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake((16.f/375)*MAIN_SCREEN_W, (13.f/667)*MAIN_SCREEN_H,MAIN_SCREEN_W-(32.f/375)*MAIN_SCREEN_W,(180.f/667)*MAIN_SCREEN_H)];
        backgroundImageView.image = [UIImage imageNamed:@"背景板"];
//        backgroundImageView.backgroundColor = [UIColor clearColor];
        self.backgroundImageView = backgroundImageView;
        [self.contentView addSubview:backgroundImageView];
        
        int padding =(160.f/375)*MAIN_SCREEN_W;
        UILabel *backgroundLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(padding, (59.f/667)*MAIN_SCREEN_H, MAIN_SCREEN_W-2*padding, (23.f/667)*MAIN_SCREEN_H)];
        backgroundLabel1.font = [UIFont systemFontOfSize:23];
        backgroundLabel1.text = @"时长";
        backgroundLabel1.textAlignment = NSTextAlignmentCenter;
        backgroundLabel1.textColor = [UIColor whiteColor];
        backgroundLabel1.backgroundColor = [UIColor clearColor];
        self.backgroundLabel1 = backgroundLabel1;
        [self.contentView addSubview:backgroundLabel1];
        int padding1 = (95.f/375)*MAIN_SCREEN_W;
        UILabel *backgroundLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_SCREEN_W-padding1-(90.f/375)*MAIN_SCREEN_W,(117.f/667)*MAIN_SCREEN_H, (80.f/375)*MAIN_SCREEN_W, (29.f/667)*MAIN_SCREEN_H)];
        backgroundLabel2.font = [UIFont systemFontOfSize:29];
        backgroundLabel2.text = @"小时";
        backgroundLabel2.textAlignment = NSTextAlignmentCenter;
        backgroundLabel2.textColor = [UIColor whiteColor];
        backgroundLabel2.backgroundColor = [UIColor clearColor];
        self.backgroundLabel2 = backgroundLabel2;
        [self.contentView addSubview:backgroundLabel2];
        
        UILabel *backgroundLabel3 = [[UILabel alloc]initWithFrame:CGRectMake((70.f/375)*MAIN_SCREEN_W,(110.f/667)*MAIN_SCREEN_H, (150.f/375)*MAIN_SCREEN_W, (40.f/667)*MAIN_SCREEN_H)];
        backgroundLabel3.font = [UIFont systemFontOfSize:40];
        backgroundLabel3.textAlignment = NSTextAlignmentCenter;
        backgroundLabel3.textColor = [UIColor whiteColor];
        backgroundLabel3.backgroundColor = [UIColor clearColor];
        self.backgroundLabel3 = backgroundLabel3;
        [self.contentView addSubview:backgroundLabel3];

    }
    return self;
}

@end
