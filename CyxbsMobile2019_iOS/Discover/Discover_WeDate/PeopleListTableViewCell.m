//
//  PeopleListTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//tableView的每一行的cell都是这个类，通过初始化的方法决定这个cell是add型还是delete型

#import "PeopleListTableViewCell.h"

@interface PeopleListTableViewCell ()
/**显示名字的大标题*/
@property (nonatomic ,strong)UILabel *nameLabel;
/**显示学号的小标题*/
@property (nonatomic, strong)UILabel *stuNumLabel;
/**储存对应的学生信息*/
@property (nonatomic, strong)NSDictionary *infoDict;
@end

@implementation PeopleListTableViewCell

- (instancetype)initWithInfoDict:(NSDictionary*)infoDict andRightBtnType:(PeopleListTableViewCellRightBtnType)type{
    self = [super init];
    if(self){
        self.infoDict = infoDict;
        [self addNameLabel];
        
        [self addStuNumLabel];
        
        if(type==PeopleListTableViewCellRightBtnTypeAdd){
            [self addAddBtn];
        }else{
            [self addDeleteBtn];
        }
    }
    return self;
}

//MARK: -初始化子控件的方法：
//添加显示姓名的大标题
- (void)addNameLabel{
    UILabel *label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    self.nameLabel = label;
    label.text =self.infoDict[@"name"];
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@".PingFang SC" size: 16];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(MAIN_SCREEN_H*0.0062);
        make.left.equalTo(self.contentView).offset(MAIN_SCREEN_W*0.0427);
        make.height.mas_equalTo(MAIN_SCREEN_H*0.0271);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
}
//添加显示学号的小标题
- (void)addStuNumLabel {
    UILabel *label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    self.stuNumLabel = label;
    label.text =self.infoDict[@"stuNum"];
    label.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@".PingFang SC" size: 11];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(MAIN_SCREEN_H*0.0062);
        make.left.equalTo(self.contentView).offset(MAIN_SCREEN_W*0.0427);
        make.height.mas_equalTo(MAIN_SCREEN_H*0.0197);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
}
//添加删除按钮
- (void)addDeleteBtn{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"草稿箱垃圾桶"] forState:UIControlStateNormal];
    [btn sizeToFit];
    float scale = 0.0271*MAIN_SCREEN_H/btn.bounds.size.height;
    btn.transform = CGAffineTransformMakeScale(scale, scale);
    
    [btn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = btn;
}

//添加add按钮
- (void)addAddBtn{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"组 207"] forState:UIControlStateNormal];
    [btn sizeToFit];
    float scale = 0.0271*MAIN_SCREEN_H/btn.bounds.size.height;
    btn.transform = CGAffineTransformMakeScale(scale, scale);
    
    [btn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = btn;
}

//MARK: - 点击某按钮后调用的方法：
//点击删除按钮后调用
- (void)deleteBtnClicked{
    [self.delegateDelete PeopleListTableViewCellDeleteBtnClickInfoDict:self.infoDict];
}
//点击add按钮后调用
- (void)addBtnClicked{
    [self.delegateAdd PeopleListTableViewCellAddBtnClickInfoDict:self.infoDict];
}

@end
