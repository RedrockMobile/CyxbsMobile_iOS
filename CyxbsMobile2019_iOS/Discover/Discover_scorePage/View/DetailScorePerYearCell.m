//
//  DetailScorePerYearCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/13.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DetailScorePerYearCell.h"
#import "DetailSubjectScoreCell.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorBackView  [UIColor colorNamed:@"Color_E8F1FC&#5A5A5A" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorWhite  [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface DetailScorePerYearCell()
@property (nonatomic, assign)int subjectCellHeight;//
@end
@implementation DetailScorePerYearCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (float)plainHeight {
    return 144;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = ColorWhite;
        } else {
            // Fallback on earlier versions
        }
        self.tableViewIsOpen = NO;
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.subjectCellHeight = 35;
        [self addTimeLabel];
        [self addBlueBackgroundView];
        [self addAverangePointLabel];
        [self addAverangePointTitleLabel];
        [self addAverangeScoreLabel];
        [self addAverangeScoreTitleLabel];
        [self addAverangeRankLabel];
        [self addAverangeRankTitleLabel];
        [self addWatchMoreButton];
    }
    return self;
}
- (void)addTimeLabel {
    UILabel *label = [[UILabel alloc]init];
    self.timeLabel = label;
    label.font = [UIFont fontWithName:PingFangSCBold size:15];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"2018-2019第二学年";
    [self.contentView addSubview:label];
}
- (void) addBlueBackgroundView {
    UIView *backView = [[UIView alloc]init];
    self.blueBackgroundView = backView;
    if (@available(iOS 11.0, *)) {
        backView.backgroundColor = ColorBackView;
    } else {
        // Fallback on earlier versions
    }
    [self.contentView addSubview:self.blueBackgroundView];
}
- (void) addAverangePointLabel {
        UILabel *averangePointLabel = [[UILabel alloc]init];
        self.averangePointLabel = averangePointLabel;
        averangePointLabel.font = [UIFont fontWithName:PingFangSCBold size:21];
        if (@available(iOS 11.0, *)) {
            averangePointLabel.textColor = Color21_49_91_F0F0F2;
        } else {
            // Fallback on earlier versions
        }
        averangePointLabel.text = @"3.4";
        [self.blueBackgroundView addSubview:averangePointLabel];
}
- (void) addAverangePointTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.averangePointTitleLabel = label;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"平均绩点";
    [self.blueBackgroundView addSubview:label];
}
- (void) addAverangeScoreLabel {
        UILabel *label = [[UILabel alloc]init];
        self.averangeScoreLabel = label;
        label.font = [UIFont fontWithName:PingFangSCBold size:21];
        if (@available(iOS 11.0, *)) {
            label.textColor = Color21_49_91_F0F0F2;
        } else {
            // Fallback on earlier versions
        }
        label.text = @"98";
        [self.blueBackgroundView addSubview:label];
}
- (void)addAverangeScoreTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.averangeScoreTitleLabel = label;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"平均成绩";
    [self.blueBackgroundView addSubview:label];
}
- (void)addAverangeRankLabel {
    UILabel *label = [[UILabel alloc]init];
    self.averangeRankLabel = label;
    label.font = [UIFont fontWithName:PingFangSCBold size:21];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"96";
    [self.blueBackgroundView addSubview:label];
}
- (void) addAverangeRankTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.averangeRankTitleLabel = label;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"平均排名";
    [self.blueBackgroundView addSubview:label];
}
- (void)addWatchMoreButton {
    UIButton *button = [[UIButton alloc]init];
    self.watchMoreButton = button;
    button.font = [UIFont fontWithName:PingFangSCRegular size:11];
    button.alpha = 0.35;
    if (@available(iOS 11.0, *)) {
        [button setTitleColor:Color21_49_91_F0F0F2 forState:normal];
    } else {
        // Fallback on earlier versions
    }
    [button setTitle:@"查看各科成绩" forState:normal];
    [self.blueBackgroundView addSubview:button];
    [button addTarget:self action:@selector(touchWatchMoreButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)touchWatchMoreButton {
    self.tableViewIsOpen = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expandSubjectScoreTableView" object:nil];
    [self.watchMoreButton setTitle:@"收起各科成绩" forState:normal];//发送消息 刷新该cell高度
    [self.watchMoreButton removeAllTargets];
    [self.watchMoreButton addTarget:self action:@selector(mergeScoreMore) forControlEvents:UIControlEventTouchUpInside];
    self.height = self.subjectCellHeight*self.singleGradesArray.count;
    self.openingHeight = self.subjectCellHeight*self.singleGradesArray.count;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.blueBackgroundView.width,0) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColor.clearColor;
    self.detailTableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.blueBackgroundView addSubview:tableView];
    [self layoutSubviews];
}
-(void)mergeScoreMore {
    self.tableViewIsOpen = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contractSubjectScoreTableView" object:nil];

    [self.watchMoreButton setTitle:@"查看各科成绩" forState:normal];
    [self.watchMoreButton removeAllTargets];
    [self.watchMoreButton addTarget:self action:@selector(touchWatchMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.5 animations:^{
        [self.detailTableView removeFromSuperview];
    }];
    self.height = [self.class plainHeight];
    

}
//MARK:  tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.singleGradesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailSubjectScoreCell*cell = [[DetailSubjectScoreCell alloc]init];
    cell.nameLabel.text = self.singleGradesArray[indexPath.row].class_name;
    cell.scoreLabel.text = self.singleGradesArray[indexPath.row].grade;
    cell.majorLabel.text = self.singleGradesArray[indexPath.row].class_type;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.subjectCellHeight;
}
//MARK: layoutSubviews
- (void)layoutSubviews {
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(28);
        make.top.equalTo(self).offset(15);
    }];
    [self.blueBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(9);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@99);
    }];
    [self.averangePointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blueBackgroundView).offset(28);
        make.top.equalTo(self.blueBackgroundView).offset(16);
    }];
    [self.averangePointTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.averangePointLabel);
        make.top.equalTo(self.averangePointLabel.mas_bottom).offset(0.68);
    }];
    [self.averangeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.blueBackgroundView);
        make.centerY.equalTo(self.averangePointLabel);
    }];
    [self.averangeScoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.averangeScoreLabel);
        make.top.equalTo(self.averangeScoreLabel.mas_bottom).offset(0.68);
    }];
    [self.averangeRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.blueBackgroundView).offset(-29);
        make.top.equalTo(self.averangePointLabel);
    }];
    [self.averangeRankTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.averangeRankLabel);
        make.top.equalTo(self.averangeRankLabel.mas_bottom).offset(0.68);
    }];
    [self.watchMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.averangeScoreLabel);
        make.bottom.equalTo(self.blueBackgroundView.mas_bottom).offset(-6);
    }];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueBackgroundView.mas_bottom).offset(20);
        make.left.right.equalTo(self.blueBackgroundView);
        make.height.equalTo(@(self.height));
    }];
}
@end
 
