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
    if (@available(iOS 11.0, *)) {
        self.backgroundColor = [UIColor colorNamed:@"QAListCellColor"];
        self.name.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.content.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.date.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.answerNum.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.integralNum.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.viewNum.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
    } else {
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1.0];
        self.name.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        self.content.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        self.date.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        self.answerNum.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        self.integralNum.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        self.viewNum.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    }
    
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#BBCAE3"];
    self.userIcon.layer.cornerRadius = 16;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
