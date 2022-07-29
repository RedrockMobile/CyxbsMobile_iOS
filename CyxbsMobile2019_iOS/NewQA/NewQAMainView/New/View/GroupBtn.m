//
//  GroupBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "GroupBtn.h"

@implementation GroupBtn

- (instancetype)init {
    if ([super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *groupBtnImageView = [[UIImageView alloc] init];
        groupBtnImageView.contentMode = UIViewContentModeScaleAspectFill;
        groupBtnImageView.clipsToBounds = YES;
        [self addSubview:groupBtnImageView];
        _groupBtnImageView = groupBtnImageView;
        
        UILabel *groupBtnLabel = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            groupBtnLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        groupBtnLabel.textAlignment = NSTextAlignmentCenter;
        groupBtnLabel.font = [UIFont fontWithName:PingFangSCRegular size: 12];
        [self addSubview:groupBtnLabel];
        _groupBtnLabel = groupBtnLabel;
        
        ///新帖子数的小蓝点
        UILabel *messageCountLabel = [[UILabel alloc] init];
        messageCountLabel.backgroundColor = [UIColor colorWithRed:41/255.0 green:35/255.0 blue:210/255.0 alpha:1.0];
        messageCountLabel.font = [UIFont fontWithName:@"Arial" size: 10];
        messageCountLabel.textColor = [UIColor whiteColor];
        messageCountLabel.textAlignment = NSTextAlignmentCenter;
        messageCountLabel.text = @"32";
        [self addSubview:messageCountLabel];
        _messageCountLabel = messageCountLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_groupBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.groupBtnLabel);
        make.height.width.mas_equalTo(SCREEN_WIDTH * 0.1228);
    }];
    _groupBtnImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1228 * 1/2;
    
    [_groupBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.groupBtnImageView.mas_bottom).mas_offset(SCREEN_WIDTH * 0.1293 * 5.5/48.5);
        make.width.mas_equalTo(self.width);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [_messageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.groupBtnImageView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.048);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.048);
    }];
    _messageCountLabel.layer.cornerRadius = SCREEN_WIDTH * 0.048 * 1/2;
    _messageCountLabel.layer.masksToBounds = YES;
}

- (void)setItem:(GroupItem *)item {
    if (item) {
        _item = item;
        [_groupBtnImageView sd_setImageWithURL:[NSURL URLWithString:item.topic_logo] placeholderImage:[UIImage imageNamed:@"圈子图像"]];
        _groupBtnLabel.text = item.topic_name;
        if (SCREEN_WIDTH * 0.1228 >= [self widthOfString:_groupBtnLabel.text]) {
            _btnWeight = SCREEN_WIDTH * 0.1228;
        } else {
            _btnWeight = [self widthOfString:_groupBtnLabel.text];
        }
        self.messageCountLabel.hidden = YES;
//        if ([item.message_count intValue] == 0) {
//            self.messageCountLabel.hidden = YES;
//        }else if ([item.message_count intValue] > 0 && [item.message_count intValue] <= 9){
//            _messageCountLabel.height = SCREEN_WIDTH * 0.048;
//            _messageCountLabel.layer.cornerRadius = SCREEN_WIDTH * 0.048 * 1/2;
//            _messageCountLabel.layer.masksToBounds = YES;
//            _messageCountLabel.text = [NSString stringWithFormat:@"%@", item.message_count];
//        }else if ([item.message_count intValue] > 9){
//            [_messageCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(self.mas_top);
//                make.right.mas_equalTo(self.groupBtnImageView.mas_right);
//                make.width.mas_equalTo(SCREEN_WIDTH * 0.068);
//                make.height.mas_equalTo(SCREEN_WIDTH * 0.048);
//            }];
//            NSString *count = [item.message_count intValue] > 99 ? @"99+":[NSString stringWithFormat:@"%@",item.message_count];
//            _messageCountLabel.text = count;
//        }
    }
}

- (CGFloat)widthOfString:(NSString *)string{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:PingFangSCRegular size: 12]};     //字体属性，设置字体的font
    CGSize maxSize = CGSizeMake(MAXFLOAT,0);
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.width);
}
@end
