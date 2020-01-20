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
//    self.userIcon = [[UIImageView alloc]init];
//    self.answerIcon = [[UIImageView alloc]init];
//    self.integralIcon = [[UIImageView alloc]init];
//    self.viewIcon = [[UIImageView alloc]init];
//    self.name = [[UILabel alloc]init];
//    self.content = [[UILabel alloc]init];
//    self.date = [[UILabel alloc]init];
//    self.answerNum = [[UILabel alloc]init];
//    self.integralNum = [[UILabel alloc]init];
//    self.viewNum = [[UILabel alloc]init];
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
