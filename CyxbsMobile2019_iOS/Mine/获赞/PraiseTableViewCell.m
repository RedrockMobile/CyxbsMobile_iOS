//
//  PraiseTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PraiseTableViewCell.h"

@interface PraiseTableViewCell()

@end
@implementation PraiseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    CCLog(@"%@",self.imageView);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PraiseTableViewCellID"];
    if (self) {
        
        self.accessoryView = [[UIView alloc] init];
    }
    return self;
}


@end


