//
//  RemarkTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RemarkTableViewCell.h"

@interface RemarkTableViewCell()

@end

@implementation RemarkTableViewCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(NSObject *)model {
    self.timeLabel.text = @"2091.10.04 19:30";
    self.textLabel.text = @"用户昵称";
    self.detailTextLabel.text = @"评论了你的评论/回复/动态";
}

@end
