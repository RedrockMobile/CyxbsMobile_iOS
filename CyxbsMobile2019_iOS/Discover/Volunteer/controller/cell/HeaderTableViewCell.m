//
//  HeaderTableViewCell.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 25/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "HeaderTableViewCell.h"

@implementation HeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"status";
    HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 2, 4, 13)];
        headerImageView.image = [UIImage imageNamed:@"标签矩形"];
        headerImageView.backgroundColor = [UIColor clearColor];
        self.headerImageView = headerImageView;
        [self.contentView addSubview:headerImageView];
        
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 2, 80, 18)];
        headerLabel.font = [UIFont systemFontOfSize:14];
        headerLabel.text = @"服务记录";
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:34/255.0 alpha:1];
        self.headerLabel = headerLabel;
        [self.contentView addSubview:headerLabel];
        
    }
    return self;
}

@end
