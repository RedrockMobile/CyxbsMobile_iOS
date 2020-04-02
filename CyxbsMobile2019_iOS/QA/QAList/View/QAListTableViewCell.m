//
//  QAListTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAListTableViewCell.h"

@implementation QAListTableViewCell
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (void)layoutSubviews{
    [self.name setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [self.content setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [self.answerNum setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
    [self.integralNum setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
    [self.viewNum setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
    [self.date setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#BDCCE5"];
    self.userIcon.layer.cornerRadius = 16;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
