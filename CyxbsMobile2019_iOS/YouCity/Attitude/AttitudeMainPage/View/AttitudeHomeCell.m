//
//  AttitudeHomeCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AttitudeHomeCell.h"

@implementation AttitudeHomeCell
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.title];
        [self setPosition];
    }
    return self;
}


// 间隙+圆角
-(void)setFrame:(CGRect)frame {
    frame.origin.x = 10; // 这里间距为10，可以根据自己的情况调整
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * frame.origin.x;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES; // 添加之后点击cell就不会发生圆角消失
    [super setFrame:frame];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont boldSystemFontOfSize:20];
        _title.numberOfLines = 0;
        // 乱写
        _title.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#111111"] darkColor:[UIColor colorWithHexString:@"#ededed"]];
        
    }
    return _title;
}

- (void)setPosition {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

@end
