//
//  MyResponseRecievedCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/25.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyResponseRecievedCell.h"
#import "MineQARecommentItem.h"

@interface MyResponseRecievedCell ()

@property (nonatomic, weak) UIImageView *sendingUserImageView;
@property (nonatomic, weak) UILabel *sendingUserNameLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIView *separateLine;

@end

@implementation MyResponseRecievedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 背景颜色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
        } else {
            // Fallback on earlier versions
        }
        
        // 评论者头像
        UIImageView *sendingUserImageView = [[UIImageView alloc] init];
        NSURL *headerImageURL = [NSURL URLWithString:[UserItemTool defaultItem].headImgUrl];
        [sendingUserImageView sd_setImageWithURL:headerImageURL placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
        [self.contentView addSubview:sendingUserImageView];
        self.sendingUserImageView = sendingUserImageView;
        
        // 评论者用户名
        UILabel *sendingUserNameLabel = [[UILabel alloc] init];
        sendingUserNameLabel.font = [UIFont systemFontOfSize:13];
        if (@available(iOS 11.0, *)) {
            sendingUserNameLabel.textColor = [UIColor colorNamed:@"Mine_QA_ContentLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:sendingUserNameLabel];
        self.sendingUserNameLabel = sendingUserNameLabel;
        
        // 评论内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:15];
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
    
    [self.sendingUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(19);
        make.top.equalTo(self.contentView).offset(17);
        make.height.width.equalTo(@48);
    }];
    
    [self.sendingUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sendingUserImageView.mas_trailing).offset(12);
        make.top.equalTo(self.sendingUserImageView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sendingUserNameLabel);
        make.bottom.equalTo(self.sendingUserImageView);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (void)setItem:(MineQARecommentItem *)item {
    NSURL *imageURL = [NSURL URLWithString:item.commenterImageURL];
    [self.sendingUserImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached context:nil progress:nil completed:nil];
    self.sendingUserNameLabel.text = item.commenterNicname;
    self.contentLabel.text = item.commentContent;
}

@end
