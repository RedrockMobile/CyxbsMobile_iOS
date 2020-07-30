//
//  PeopleListTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PeopleListTableViewCell.h"

@interface PeopleListTableViewCell ()
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *stuNumLabel;
@property (nonatomic, strong)NSDictionary *infoDict;
@end

@implementation PeopleListTableViewCell

- (instancetype)initWithInfoDict:(NSDictionary*)infoDict andRightBtnType:(PeopleListTableViewCellRightBtnType)type{
    self = [super init];
    if(self){
        self.infoDict = infoDict;
        
    }
    return self;
}

- (void)addNameLabel{
    UILabel *label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    self.nameLabel = label;
    label.text =self.infoDict[@"name"];
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@".PingFang SC" size: 16];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(MAIN_SCREEN_H*0.015);
        make.left.equalTo(self.contentView).offset(MAIN_SCREEN_W*0.0427);
        make.height.mas_equalTo(MAIN_SCREEN_H*2.71);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
}

- (void)addStuNumLabel {
    UILabel *label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    self.stuNumLabel = label;
    label.text =self.infoDict[@"stuNum"];
    label.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@".PingFang SC" size: 11];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel).offset(MAIN_SCREEN_H*0.0062);
        make.left.equalTo(self.contentView).offset(MAIN_SCREEN_W*0.0427);
        make.height.mas_equalTo(MAIN_SCREEN_H*0.0197);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
}

- (void)addDeleteBtn{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"草稿箱垃圾桶"] forState:UIControlStateNormal];
    [btn sizeToFit];
    float scale = 0.0271*MAIN_SCREEN_H/btn.bounds.size.height;
    btn.transform = CGAffineTransformMakeScale(scale, scale);
    
    [btn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = btn;
}

- (void)addAddBtn{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"组 207"] forState:UIControlStateNormal];
    [btn sizeToFit];
    float scale = 0.0271*MAIN_SCREEN_H/btn.bounds.size.height;
    btn.transform = CGAffineTransformMakeScale(scale, scale);
    
    [btn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = btn;
}

- (void)deleteBtnClicked{
    [self.delegateDelete PeopleListTableViewCellDeleteBtnClickInfoDict:self.infoDict];
}
- (void)addBtnClicked{
    [self.delegateAdd PeopleListTableViewCellAddBtnClickInfoDict:self.infoDict];
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
