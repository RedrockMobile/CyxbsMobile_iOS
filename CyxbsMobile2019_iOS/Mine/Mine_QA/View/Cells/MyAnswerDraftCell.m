//
//  MyAnswerDraftCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/25.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyAnswerDraftCell.h"
#import "MineQAMyAnswerDraftItem.h"

@interface MyAnswerDraftCell ()

@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIButton *deleteButton;
@property (nonatomic, weak) UIView *separateLine;

@end

@implementation MyAnswerDraftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 背景颜色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
        } else {
            // Fallback on earlier versions
        }
        
        // 内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 1;
        contentLabel.font = [UIFont systemFontOfSize:15];
        if (@available(iOS 11.0, *)) {
            contentLabel.textColor = [UIColor colorNamed:@"Mine_QA_ContentLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        // 时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"2019.8.22";
        timeLabel.font = [UIFont systemFontOfSize:11];
        if (@available(iOS 11.0, *)) {
            timeLabel.textColor = [UIColor colorNamed:@"Mine_QA_TimeLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 删除
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"我的草稿箱垃圾桶"] forState:UIControlStateNormal];
        [self.contentView addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        UIView *separateLine = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            separateLine.backgroundColor = [UIColor colorNamed:@"Mine_QA_SeparateLineColor"];
        } else {
            separateLine.backgroundColor = [UIColor colorWithRed:192/255.0 green:204/255.0 blue:227/255.0 alpha:1];
        }
        [self addSubview:separateLine];
        self.separateLine = separateLine;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@18);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.top.equalTo(@15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentLabel);
        make.bottom.equalTo(self.contentView).offset(-17);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-19);
        make.height.width.equalTo(@19);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (void)setItem:(MineQAMyAnswerDraftItem *)item {
    self.contentLabel.text = item.answerDraftContent;
    self.timeLabel.text = item.lastEditTime;
}

@end
