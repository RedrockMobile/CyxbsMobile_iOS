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
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(NSObject *)model {
    self.timeLabel.text = @"2091.10.04 19:30";
    self.textLabel.text = @"用户昵称";
    self.detailTextLabel.text = @"赞了你的评论/回复/动态";
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end



