//
//  InstallBuildTableViewCell.m
//  Query
//
//  Created by hzl on 2017/3/9.
//  Copyright © 2017年 c. All rights reserved.
//

#import "InstallBuildTableViewCell.h"
#import "buildCircleView.h"
#import "AppDelegate.h"


CG_INLINE CGRect
CHANGE_CGRectMake(CGFloat x, CGFloat y,CGFloat width,CGFloat height){
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleY;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

@implementation InstallBuildTableViewCell

+ (instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    InstallBuildTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[InstallBuildTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        return cell;
}



- (void)setUpUI{
    _buildLabel = [[UILabel alloc] initWithFrame:CHANGE_CGRectMake(49, 13.5, 40, 15.5)];
    _buildLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    _buildLabel.backgroundColor = [UIColor clearColor];
    _buildLabel.font = [UIFont systemFontOfSize:font(17)];
    _buildLabel.contentMode = UIViewContentModeCenter;
    _buildLabel.numberOfLines = 0;
    
    buildCircleView *circle = [[buildCircleView alloc] initWithFrame:CHANGE_CGRectMake(16.5, 18, 7.5, 7.5)];
    
    [self.contentView addSubview:_buildLabel];
    [self.contentView addSubview:circle];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
