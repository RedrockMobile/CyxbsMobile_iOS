//
//  YearTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "YearTableViewCell.h"

@implementation YearTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        ///设置cell的背景色和cell.contentView的背景色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"MGDActivityBackColor"];
        } else {
            // Fallback on earlier versions
        }
        [self BuildUI];
        ///设置contentView的顶部左右两个圆角
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.frame;
//        maskLayer.path = maskPath.CGPath;
//        self.layer.mask = maskLayer;
//        self.contentView.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)BuildUI {
    UILabel *yearLabel = [[UILabel alloc] init];
    if (@available(iOS 11.0, *)) {
        yearLabel.textColor = [UIColor colorNamed:@"MGDLoginTitleColor"];
    } else {
        // Fallback on earlier versions
    }
    yearLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PickerViewClicked:) name:@"YearClicked" object:nil];
    [self.contentView addSubview:yearLabel];
    _yearLabel = yearLabel;
    
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.0163);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.048);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1573);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0302);
    }];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [chooseBtn setImage:[UIImage imageNamed:@"年份选择"] forState:UIControlStateNormal];
    [chooseBtn setImage:[UIImage imageNamed:@"年份选择"] forState:UIControlStateHighlighted];
    [chooseBtn addTarget:self action:@selector(yearChooseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:chooseBtn];
    _chooseBtn = chooseBtn;
    
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.0246);
        make.left.mas_equalTo(self.yearLabel.mas_right).mas_offset(SCREEN_WIDTH * 0.01);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0365);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0101);
    }];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12];
    if (@available(iOS 11.0, *)) {
        totalLabel.textColor = [UIColor colorNamed:@"MGDYearCellTotalColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.contentView addSubview:totalLabel];
    _totalLabel = totalLabel;
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.0201);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0587);
        make.left.mas_equalTo(self.chooseBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.03);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0245);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        lineView.backgroundColor = [UIColor colorNamed:@"MGDTimeCellHourColor"];
    } else {
        // Fallback on earlier versions
    }
    lineView.alpha = 0.1;
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-2);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];

}

- (void)yearChooseBtnClicked{
    if ([self.delegate respondsToSelector:@selector(yearChooseBtnClicked)]) {
        [self.delegate yearChooseBtnClicked];
    }
}

- (void)PickerViewClicked:(NSNotification *)center {
//    NSString *year = center.userInfo[@"year"];
//    _yearLabel.text = year;
}



@end
