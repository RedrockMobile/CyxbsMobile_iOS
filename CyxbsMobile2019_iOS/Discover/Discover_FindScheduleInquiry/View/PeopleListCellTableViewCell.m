//
//  PeopleListCellTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PeopleListCellTableViewCell.h"
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132&#DFDFE3" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@implementation PeopleListCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.imageView setImage:[UIImage imageNamed:@"defaultStudentImage"]];
        self.textLabel.textColor = Color21_49_91_F0F0F2;
        self.textLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
        self.detailTextLabel.textColor = Color21_49_91_F0F0F2;
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:13];
        [self addStuNumLabel];
    }
    return self;
}
-(void) addStuNumLabel {
    UILabel *label = [[UILabel alloc]init];
    [self.contentView addSubview:label];
    self.stuNumLabel = label;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    label.textColor = Color42_78_132;
}
- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(19, 18, 48, 48);
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.top.equalTo(self).offset(17);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).offset(7);
    }];
    [self.stuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.right.equalTo(self).offset(-15);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
