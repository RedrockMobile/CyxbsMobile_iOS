//
//  MyResponseSentCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/25.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyResponseSentCell.h"
#import "MineQACommentItem.h"

@interface MyResponseSentCell ()

@property (nonatomic, weak) UILabel *sendToNameLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIView *separateLine;

@end

@implementation MyResponseSentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 背景颜色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
        } else {
            // Fallback on earlier versions
        }
        
        UILabel *sendToNameLabel = [[UILabel alloc] init];
        sendToNameLabel.font = [UIFont systemFontOfSize:13];
        sendToNameLabel.alpha = 0.7;
        if (@available(iOS 11.0, *)) {
            sendToNameLabel.textColor = [UIColor colorNamed:@"Mine_QA_ContentLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:sendToNameLabel];
        self.sendToNameLabel = sendToNameLabel;
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.numberOfLines = 1;
        if (@available(iOS 11.0, *)) {
            contentLabel.textColor = [UIColor colorNamed:@"Mine_QA_ContentLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
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
    
    [self.sendToNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sendToNameLabel);
        make.top.equalTo(self.sendToNameLabel.mas_bottom).offset(11);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (void)setItem:(MineQACommentItem *)item {
    self.sendToNameLabel.text = item.answerer;
    self.contentLabel.text = item.commentContent;
}

@end
