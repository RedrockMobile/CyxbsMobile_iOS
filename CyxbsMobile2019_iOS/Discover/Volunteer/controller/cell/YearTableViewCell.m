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
        self.backgroundColor = [UIColor clearColor];
        [self BuildUI];
        ///设置contentView的顶部左右两个圆角
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.contentView.layer.mask = maskLayer;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)BuildUI {
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
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
    totalLabel.textColor = [UIColor colorWithRed:58/255.0 green:57/255.0 blue:211/255.0 alpha:1.0];
    [self.contentView addSubview:totalLabel];
    _totalLabel = totalLabel;
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.0201);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0587);
        make.left.mas_equalTo(self.chooseBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.03);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0245);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:78.0/255.0 blue:132.0/255.0 alpha:1];
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
