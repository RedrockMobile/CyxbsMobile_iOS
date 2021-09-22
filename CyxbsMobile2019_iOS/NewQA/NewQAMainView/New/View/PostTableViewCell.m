//
//  PostTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PostTableViewCell.h"
#import "MGDImageCollectionViewCell.h"
#import "PostModel.h"
#import "StarPostModel.h"
#import <YBImageBrowser.h>


#define Pading SCREEN_WIDTH*0.0427
#define Margin 7
#define item_num 3

@interface PostTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation PostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorNamed:@"TableViewBackColor"];
        [self BuildUI];
//        [self BuildFrame];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    }
    return self;
}

-(void)reloadCellView{
    [self BuildUI];
}

- (void)BuildUI {
    ///头像
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1066 * 1/2;
    [self.contentView addSubview:_iconImageView];
    
    ///昵称
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    _nicknameLabel.font = [UIFont fontWithName:PingFangSCSemibold size: 17];
    _nicknameLabel.backgroundColor = [UIColor orangeColor];
    _nicknameLabel.textColor = [UIColor colorNamed:@"CellUserNameColor"];
    [self.contentView addSubview:_nicknameLabel];
    
    ///时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont fontWithName:PingFangSCMedium size: 11];
    _timeLabel.textColor = [UIColor colorNamed:@"CellDateColor"];
    [self.contentView addSubview:_timeLabel];
    
    ///多功能按钮
    _funcBtn = [[UIButton alloc] init];
    _funcBtn.backgroundColor = [UIColor clearColor];
    [_funcBtn setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
    [_funcBtn addTarget:self action:@selector(ClickedFuncBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_funcBtn];
    
    ///内容
    _detailLabel = [[NewQAPostDetailLabel alloc] initWithFrame:self.bounds];
    _detailLabel.textColor = [UIColor colorNamed:@"CellDetailColor"];
    self.detailLabel.font = [UIFont fontWithName:PingFangSCRegular size:16];
    self.detailLabel.backgroundColor = [UIColor blueColor];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    // 多行设置
    self.detailLabel.numberOfLines = 5;
    self.detailLabel.preferredMaxLayoutWidth = WScaleRate_SE * 342;
    [self.detailLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:_detailLabel];

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectView = [[NewQACellCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectView.backgroundColor = [UIColor clearColor];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.scrollEnabled = NO;
    [_collectView registerClass:[MGDImageCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.contentView addSubview:_collectView];
    
    ///标签
    _groupLabel = [[UIButton alloc] init];
    _groupLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_groupLabel.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size: 12.08]];
    if (@available(iOS 11.0, *)) {
        [_groupLabel setTitleColor:[UIColor colorNamed:@"CellGroupColor"] forState:UIControlStateNormal];
        _groupLabel.backgroundColor = [UIColor colorNamed:@"CELLTOPICBACKCOLOR"];
    } else {
        [_groupLabel setTitleColor:[UIColor colorWithRed:85.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1] forState:UIControlStateNormal];
        _groupLabel.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1];
    }
    [_groupLabel addTarget:self action:@selector(ClickedGroupTopicBtn) forControlEvents:UIControlEventTouchUpInside];
    _groupLabel.layer.cornerRadius = SCREEN_WIDTH * 0.2707 * 25.5/101.5 * 1/2;
    [self.contentView addSubview:_groupLabel];
    
    ///点赞
    _starBtn = [[FunctionBtn alloc] init];
    [_starBtn addTarget:self action:@selector(ClickedStar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_starBtn];
    
    MGDClickParams *params = [[MGDClickParams alloc] init];
    params.circleCount = 10;    // 周围外层圈圈个数
    params.animationDuration = 1.6;   // 动画持续时间
    params.smallCircleOffsetAngle = -2;
    _starBtn.params = params;
    
    ///评论
    _commendBtn = [[FunctionBtn alloc] init];
    _commendBtn.iconView.image = [UIImage imageNamed:@"answerIcon"];
    [_commendBtn addTarget:self action:@selector(ClickedComment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commendBtn];
    
    ///分享
    _shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _shareBtn.backgroundColor = [UIColor clearColor];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(ClickedShare) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shareBtn];
    
}

//- (void)BuildFrame {
//    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_WIDTH * 0.0427);
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
//        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.1066);
//    }];
//    _iconImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1066 * 1/2;
//
//    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_WIDTH * 0.0427 + 2);
//        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(SCREEN_WIDTH * 0.04);
//        make.right.mas_equalTo(self.funcBtn.mas_right).mas_offset(-SCREEN_WIDTH * 0.5);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.1381 * 14.5/43.5);
//    }];
//
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.nicknameLabel.mas_bottom).mas_offset(9);
//        make.left.right.mas_equalTo(self.nicknameLabel);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.1794 * 9/56.5);
//    }];
//
//    [_funcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_WIDTH * 0.89 * 18/343);
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.89);
//        make.right.mas_equalTo(self.contentView.mas_right);
//        make.height.mas_equalTo((SCREEN_WIDTH * 0.89 * 18/343 + [UIImage imageNamed:@"QAMoreButton"].size.height));
//    }];
//    [_funcBtn setImageEdgeInsets:UIEdgeInsetsMake((SCREEN_WIDTH * 0.89 * 18/343 - [UIImage imageNamed:@"QAMoreButton"].size.height), 0, 0, (SCREEN_WIDTH * 0.11 - [UIImage imageNamed:@"QAMoreButton"].size.width))];
//
//
//    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(SCREEN_WIDTH * 0.0427 * 14.5/16);
//        make.left.mas_equalTo(self.iconImageView);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
//        make.height.mas_equalTo(1).priorityLow();
//    }];
//
//    [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_detailLabel.mas_bottom).mas_offset(Pading * 13.5/16);
//        make.left.mas_equalTo(_detailLabel);
//        make.width.mas_equalTo(SCREEN_WIDTH - Pading * 2);
//        make.height.mas_equalTo(1).priorityLow();
//    }];
//
//    [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.2707 * 25.5/101.5);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-Pading * 62.5/16);
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.0413);
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.2707);
//    }];
//    _groupLabel.layer.cornerRadius = SCREEN_WIDTH * 0.2707 * 25.5/101.5 * 1/2;
//
//    [_starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.groupLabel.mas_bottom).mas_offset(SCREEN_WIDTH * 0.5653 * 20.5/212);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 22.75/20.05);
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.5587);
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
//    }];
//
//    [_commendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.groupLabel.mas_bottom).mas_offset(SCREEN_WIDTH * 0.5653 * 20.5/212);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 22.75/20.05);
//        make.left.mas_equalTo(self.starBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.01);
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
//    }];
//
//    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.commendBtn);
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.0547);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 22.75/20.05);
//    }];
//    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//}

-(void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
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
        _item = item;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"圈子图像"]];
        self.nicknameLabel.text = item.nick_name;
        self.timeLabel.text = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@",item.publish_time]];
        self.detailLabel.text = item.content;
        self.collectView.item = item;
        [self.groupLabel setTitle:[NSString stringWithFormat:@"# %@",item.topic] forState:UIControlStateNormal];
//        NSString *content = self.groupLabel.titleLabel.text;
//        UIFont *font = self.groupLabel.titleLabel.font;
//        CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
//        CGSize buttonSize = [content boundingRectWithSize:size
//        options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//        attributes:@{ NSFontAttributeName:font}
//        context:nil].size;
//        [_groupLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.collectView.mas_bottom).mas_offset(11);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-Pading * 62.5/16);
//            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.0413);
//            make.width.mas_equalTo(buttonSize.width + SCREEN_WIDTH * 0.05 * 2);
//        }];
        self.commendBtn.countLabel.text = [NSString stringWithFormat:@"%@",item.comment_count];
        self.starBtn.countLabel.text = [NSString stringWithFormat:@"%@",item.praise_count];
        self.starBtn.selected = [item.is_praised intValue] == 1 ? YES : NO;
        self.starBtn.countLabel.textColor = self.starBtn.selected == YES ? [UIColor colorNamed:@"countLabelColor"] : [UIColor colorNamed:@"FuncBtnColor"];
            self.commendBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        self.starBtn.isFirst = YES;
        [self.starBtn setIconViewSelectedImage:[UIImage imageNamed:@"点赞"] AndUnSelectedImage:[UIImage imageNamed:@"未点赞"]];
//        self.starBtn.isSelected = self.starBtn.selected;
//        [self reloadCell:item.pics];
    }
}

- (void)reloadCell:(NSArray *)imgarr{
    [self.collectView reloadData];
    [self.collectView layoutIfNeeded];
    [self.collectView setNeedsLayout];
    CGFloat height_pading;
    CGFloat height_collectionview;
    if (imgarr.count == 0) {
        height_pading = 0;
        height_collectionview = 0;
    }else {
        height_pading = 13.5;
        height_collectionview = self.collectView.collectionViewLayout.collectionViewContentSize.height;
    }
//    self.collectView.frame = CGRectMake(WScaleRate_SE * 16, self.detailLabel.origin.y + self.detailLabel.frame.size.height + height_pading, WScaleRate_SE * 342, height_collectionview);
//
    [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_offset(height_pading);
        make.left.mas_equalTo(_detailLabel);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * Pading);
        make.height.mas_equalTo(height_collectionview);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *tagsArr = _item.pics;
    if (tagsArr.count > 3) {
        return 3;
    }
    return tagsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGDImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    NSArray *tagsArr = _item.pics;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:tagsArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"寂静"]];

    if (indexPath.row == 2 && tagsArr.count > 3) {
        unsigned long diff = tagsArr.count - 3;
        NSString *count = [NSString stringWithFormat:@"+%lu",diff];
        cell.countLabel.text = count;
        cell.countLabel.hidden = NO;
    }
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat item_height = (SCREEN_WIDTH-(2 * Margin + Pading * 2))/item_num;
    CGSize size = CGSizeMake(item_height,item_height);
    return size;
}

//这个是两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//两个cell之间的最小间距间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0;i < [_item.pics count]; i++) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:_item.pics[i]];
        [photos addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = photos;
    browser.currentPage = indexPath.row;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}


//获取文字所需行数
- (NSInteger)needLinesWithWidth:(CGFloat)width currentLabel:(UILabel *)currentLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = currentLabel.font;
    NSString *text = currentLabel.text;
    NSInteger sum = 0;
    //加上换行符
    NSArray *rowType = [text componentsSeparatedByString:@"\n"];
    for (NSString *currentText in rowType) {
        label.text = currentText;
        //获取需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        NSInteger lines = ceil(textSize.width/width);
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;
}

///时间戳转具体日期
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
   NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
   NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
   [formatter setDateFormat:@"YYYY-MM-dd"];
   NSString *timeStr=[formatter stringFromDate:myDate];
   return timeStr;
}

- (void)ClickedFuncBtn {
    if ([self.delegate respondsToSelector:@selector(ClickedFuncBtn:)]) {
        [self.delegate ClickedFuncBtn:self];
    }
}

///点赞的逻辑：点赞后，本地改变点赞的数值，然后通过网络请求传入后端
- (void)ClickedStar {
    if ([self.delegate respondsToSelector:@selector(ClickedStarBtn:)]) {
        [self.delegate ClickedStarBtn:self];
    }
}

///跳转到具体的评论界面
- (void)ClickedComment {
    if ([self.delegate respondsToSelector:@selector(ClickedCommentBtn:)]) {
        [self.delegate ClickedCommentBtn:self];
    }
}

///分享
- (void)ClickedShare {
    if ([self.delegate respondsToSelector:@selector(ClickedShareBtn:)]) {
        [self.delegate ClickedShareBtn:self];
    }
}

///点击标签跳转进相应的圈子
- (void)ClickedGroupTopicBtn {
    if ([self.delegate respondsToSelector:@selector(ClickedGroupTopicBtn:)]) {
        [self.delegate ClickedGroupTopicBtn:self];
    }
}

- (void)setCellFrame:(PostTableViewCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    _iconImageView.frame = cellFrame.iconImageViewFrame;
    _nicknameLabel.frame = cellFrame.nicknameLabelFrame;
    _timeLabel.frame = cellFrame.timeLabelFrame;
    _funcBtn.frame = cellFrame.funcBtnFrame;
    _detailLabel.frame = cellFrame.detailLabelFrame;
    _collectView.frame = cellFrame.collectViewFrame;
    _groupLabel.frame = cellFrame.groupLabelFrame;
    _starBtn.frame = cellFrame.starBtnFrame;
    _commendBtn.frame = cellFrame.commendBtnFrame;
    _shareBtn.frame = cellFrame.shareBtnFrame;
}
@end
