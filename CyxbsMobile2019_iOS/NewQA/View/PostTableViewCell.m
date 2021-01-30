//
//  PostTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PostTableViewCell.h"
#import "PostModel.h"
#import "StarPostModel.h"
#import "GKPhotoBrowser.h"
#import "GKPhoto.h"

@interface PostTableViewCell()
@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation PostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"TableViewBackColor"];
        } else {
            // Fallback on earlier versions
        }
        [self BuildUI];
        [self BuildFrame];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)BuildUI {
    ///头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    ///昵称
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.textAlignment = NSTextAlignmentLeft;
    nicknameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 15];
    if (@available(iOS 11.0, *)) {
        nicknameLabel.textColor = [UIColor colorNamed:@"CellUserNameColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.contentView addSubview:nicknameLabel];
    _nicknameLabel = nicknameLabel;
    
    ///时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    if (@available(iOS 11.0, *)) {
        timeLabel.textColor = [UIColor colorNamed:@"CellDateColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    ///多功能按钮
    UIButton *funcBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    funcBtn.backgroundColor = [UIColor clearColor];
    [funcBtn setBackgroundImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
    [funcBtn addTarget:self action:@selector(ClickedFuncBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:funcBtn];
    _funcBtn = funcBtn;
    
    ///内容
    UILabel *detailLabel = [[UILabel alloc] init];
    if (@available(iOS 11.0, *)) {
        detailLabel.textColor = [UIColor colorNamed:@"CellDetailColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.contentView addSubview:detailLabel];
    _detailLabel = detailLabel;
    
    _tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickedImageView1:)];
    _tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickedImageView2:)];
    _tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickedImageView3:)];
    ///三张图片
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.backgroundColor = [UIColor clearColor];
    imageView1.layer.cornerRadius = 7.5;
    imageView1.layer.masksToBounds = YES;
    imageView1.userInteractionEnabled = YES;
    [imageView1 addGestureRecognizer:_tap1];
    [self.contentView addSubview:imageView1];
    _imageView1 = imageView1;
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.backgroundColor = [UIColor clearColor];
    imageView2.layer.cornerRadius = 7.5;
    imageView2.layer.masksToBounds = YES;
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:_tap2];
    [self.contentView addSubview:imageView2];
    _imageView2 = imageView2;
    
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.backgroundColor = [UIColor clearColor];
    imageView3.layer.cornerRadius = 7.5;
    imageView3.layer.masksToBounds = YES;
    imageView3.userInteractionEnabled = YES;
    [imageView3 addGestureRecognizer:_tap3];
    [self.contentView addSubview:imageView3];
    _imageView3 = imageView3;
    
    ///标签
    UIButton *groupLabel = [[UIButton alloc] init];
    _groupImage = [UIImage imageNamed:@"标签背景"];
    [groupLabel setBackgroundImage:_groupImage forState:UIControlStateNormal];
    groupLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [groupLabel.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 12.08]];
    if (@available(iOS 11.0, *)) {
        [groupLabel setTitleColor:[UIColor colorNamed:@"CellGroupColor"] forState:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
    }
    [self.contentView addSubview:groupLabel];
    _groupLabel = groupLabel;
    
    ///点赞
    FunctionBtn *starBtn = [[FunctionBtn alloc] init];
    [starBtn addTarget:self action:@selector(ClickedStar:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:starBtn];
    _starBtn = starBtn;
    
    ///评论
    FunctionBtn *commendBtn = [[FunctionBtn alloc] init];
    commendBtn.iconView.image = [UIImage imageNamed:@"answerIcon"];
    [commendBtn addTarget:self action:@selector(ClickedComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commendBtn];
    _commendBtn = commendBtn;
    
    ///分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(ClickedShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareBtn];
    _shareBtn = shareBtn;
    
}

- (void)BuildFrame {
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_HEIGHT * 0.024);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.1066);
    }];
    _iconImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1066 * 1/2;
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0285);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(SCREEN_WIDTH * 0.04);
        make.right.mas_equalTo(self.funcBtn.mas_right).mas_offset(-SCREEN_WIDTH * 0.04);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.1381 * 14.5/43.5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nicknameLabel.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0135);
        make.left.right.mas_equalTo(self.nicknameLabel);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.1794 * 9/56.5);
    }];
    
    [_funcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.051);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.89);
        make.width.mas_equalTo([UIImage imageNamed:@"QAMoreButton"].size.width);
        make.height.mas_equalTo([UIImage imageNamed:@"QAMoreButton"].size.height);
    }];
    
    UIView *currentView = self.detailLabel;
    [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.021);
        make.left.mas_equalTo(self.iconImageView);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
    }];
    self.detailLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    // 多行设置
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - SCREEN_WIDTH * 0.0427 * 2);
    [self.detailLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    currentView = self.detailLabel;
    
    
    CGFloat W = SCREEN_WIDTH * 0.2969;
    [_imageView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0202);
        make.left.mas_equalTo(self.iconImageView.mas_left).mas_offset(SCREEN_WIDTH * 0.0013);
        make.width.height.mas_equalTo(W);
    }];

    [_imageView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView1);
        make.width.height.mas_equalTo(W);
        make.left.mas_equalTo(self.imageView1.mas_right).mas_offset(SCREEN_WIDTH * 0.012);
    }];

    [_imageView3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(_imageView1);
        make.width.height.mas_equalTo(W);
        make.left.mas_equalTo(self.imageView2.mas_right).mas_offset(SCREEN_WIDTH * 0.012);
    }];
    
    [_groupLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView1.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0165 + _imageView1.frame.size.height);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-SCREEN_HEIGHT * 0.093);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.0413);
        make.width.mas_equalTo(_groupImage.size);
    }];
    
    [_starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.groupLabel.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0225);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 20.75/20.05);
        make.left.mas_equalTo(self.groupLabel.mas_right).mas_offset(SCREEN_WIDTH * 0.2467);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
    }];
    
    [_commendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self.starBtn);
        make.left.mas_equalTo(self.starBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.01);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.starBtn);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0547);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark- setter
- (void)setItem:(PostItem *)item {
    if (item) {
        self.iconImageView.image = [UIImage imageNamed:@"圈子图像"];
//        self.nicknameLabel.text = item.nick_name;
        self.nicknameLabel.text = @"测试name";
        self.timeLabel.text = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@",item.publish_time]];
        self.detailLabel.text = item.content;
        ///对cell中图像的一些操作
        if ([item.pics count] == 0) {
            [self.imageView1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [self.imageView2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [self.imageView3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }else if ([item.pics count] > 3) {
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:item.pics[0]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:item.pics[1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
            [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:item.pics[2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
            UILabel *imageCountLabel = [self ImageCountLabel];
            imageCountLabel.text = [NSString stringWithFormat:@"+%lu",[item.pics count] - 3];
            [self.imageView3 addSubview:imageCountLabel];
            [imageCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(self.imageView3);
            }];
        }else if ([item.pics count] == 1) {
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:@"http://cdn.redrock.team/magipoke-loop_mnWUCn7lYHirlfk4H4B0x7ypY8ES2GtT.CBjIKw7hBK8mFnvHkc8gqw9D4C36CWEE"] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
            self.imageView2.userInteractionEnabled = NO;
            self.imageView3.userInteractionEnabled = NO;
        }else if ([item.pics count] == 2) {
            self.imageView3.userInteractionEnabled = NO;
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:item.pics[0]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:item.pics[1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
        }else if ([item.pics count] == 3) {
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:item.pics[0]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:item.pics[1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
            [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:item.pics[2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] options:SDWebImageRefreshCached];
        }
        [self.groupLabel setTitle:[NSString stringWithFormat:@"# %@",item.topic] forState:UIControlStateNormal];
        self.commendBtn.countLabel.text = [NSString stringWithFormat:@"%d",123];
        self.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",3243];
        self.starBtn.selected = [item.is_praised intValue] == 1 ? YES : NO;
        if (@available(iOS 11.0, *)) {
            self.starBtn.countLabel.textColor = self.starBtn.selected == YES ? [UIColor colorNamed:@"countLabelColor"] : [UIColor colorNamed:@"FuncBtnColor"];
            self.commendBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.starBtn setIconViewSelectedImage:[UIImage imageNamed:@"点赞"] AndUnSelectedImage:[UIImage imageNamed:@"未点赞"]];
    }
}

///时间戳转具体日期
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
   NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
   NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
   [formatter setDateFormat:@"YYYY-MM-dd"];
   NSString *timeStr=[formatter stringFromDate:myDate];
   return timeStr;
}

///图片多余三张时的蒙版文字
- (UILabel *)ImageCountLabel {
    UILabel *imageCountLabel = [[UILabel alloc] init];
    imageCountLabel.backgroundColor = [UIColor blackColor];
    imageCountLabel.alpha = 0.5;
    imageCountLabel.textAlignment = NSTextAlignmentCenter;
    imageCountLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    imageCountLabel.font = [UIFont fontWithName:@"Arial" size: 30];
    imageCountLabel.layer.masksToBounds = YES;
    return imageCountLabel;
}

- (void)ClickedFuncBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedFuncBtn:)]) {
        [self.delegate ClickedFuncBtn:sender];
    }
}

///点赞的逻辑：点赞后，本地改变点赞的数值，然后通过网络请求传入后端
- (void)ClickedStar:(FunctionBtn *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedStarBtn:)]) {
        [self.delegate ClickedStarBtn:sender];
    }
}

///跳转到具体的评论界面
- (void)ClickedComment:(FunctionBtn *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedCommentBtn:)]) {
        [self.delegate ClickedCommentBtn:sender];
    }
}

///分享
- (void)ClickedShare:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedShareBtn:)]) {
        [self.delegate ClickedShareBtn:sender];
    }
}

///点击第一张图片
- (void)ClickedImageView1:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(ClickedImageView1:)]) {
        [self.delegate ClickedImageView1:tap];
    }
}

///点击第二张图片
- (void)ClickedImageView2:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(ClickedImageView2:)]) {
        [self.delegate ClickedImageView2:tap];
    }
}

///点击第三张图片
- (void)ClickedImageView3:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(ClickedImageView3:)]) {
        [self.delegate ClickedImageView3:tap];
    }
}

@end


