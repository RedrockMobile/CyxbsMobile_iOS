//
//  ExpressDetailCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressDetailCell.h"

@implementation ExpressDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#0028FC" alpha:0.5];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.checkImage];
        [self.contentView addSubview:self.checkImage];
        [self setPosition];
    }
    return self;
}

- (void)setPosition {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).mas_offset(36);
    }];
    [self.checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).mas_offset(54);
    }];
    [self.percent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.checkImage).mas_offset(12);
    }];
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.origin.y += 20;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * frame.origin.x;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 30;
    self.clipsToBounds = YES;
    
    [super setFrame:frame];
}

- (UILabel *)title {
    if (_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#15315B"];
        _title.font = [UIFont fontWithName:PingFangSC size:14];
        
    }
    return _title;
}
- (UIImageView *)checkImage {
    if (_checkImage) {
        _checkImage = [[UIImageView alloc] init];
        _checkImage.image = [UIImage imageNamed:@"Express_vector"];
        
    }
    return _checkImage;
}
- (UILabel *)percent {
    if (_percent) {
        _percent = [[UILabel alloc] init];
        _percent.textColor = [UIColor whiteColor];
        _percent.font = [UIFont fontWithName:PingFangSC size:12];
    }
    return _percent;
}

@end
