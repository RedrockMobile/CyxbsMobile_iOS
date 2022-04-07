//
//  DownFileDetailCellTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/9.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DownFileDetailCellTableViewCell.h"

@implementation DownFileDetailCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.text = @"这是一个很普通的附件";
        self.imageView.image = [UIImage imageNamed:@"fileDownload"];
    }
    return self;
}

- (void)layoutSubviews {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.height.width.equalTo(@40);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.right.lessThanOrEqualTo(self.imageView.mas_left).offset(-10);
    }];
}

@end
