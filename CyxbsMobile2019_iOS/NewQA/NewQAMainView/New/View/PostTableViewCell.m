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
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
        [self BuildUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [NSUserDefaults.standardUserDefaults setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
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
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1066 * 1/2;
    [self.contentView addSubview:_iconImageView];
    
    ///昵称
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    _nicknameLabel.font = [UIFont fontWithName:PingFangSCSemibold size: 17];
    _nicknameLabel.backgroundColor = [UIColor clearColor];
    _nicknameLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self.contentView addSubview:_nicknameLabel];
    
    _IdentifyBackImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_IdentifyBackImage];
    
    ///时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont fontWithName:PingFangSCMedium size: 11];
    _timeLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.7] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.7]];
    [self.contentView addSubview:_timeLabel];
    
    ///多功能按钮
    _funcBtn = [[UIButton alloc] init];
    _funcBtn.backgroundColor = [UIColor clearColor];
    [_funcBtn setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
    [_funcBtn addTarget:self action:@selector(ClickedFuncBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_funcBtn];
    
    ///内容
    _detailLabel = [[NewQAPostDetailLabel alloc] initWithFrame:self.bounds];
    _detailLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C57" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    self.detailLabel.font = [UIFont fontWithName:PingFangSCRegular size:16];
    self.detailLabel.backgroundColor = [UIColor clearColor];
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
    _groupLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_groupLabel.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size: 12.08]];
    [_groupLabel setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#255295" alpha:0.7] darkColor:[UIColor colorWithHexString:@"#CBD3E9" alpha:0.7]] forState:UIControlStateNormal];
    _groupLabel.backgroundColor = [UIColor clearColor];
    [_groupLabel addTarget:self action:@selector(ClickedGroupTopicBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_groupLabel];
    
    ///点赞
    _starBtn = [[FunctionBtn alloc] init];
    [_starBtn addTarget:self action:@selector(ClickedStar) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_starBtn];
    
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
        [self.IdentifyBackImage sd_setImageWithURL:[NSURL URLWithString:item.identity_pic] placeholderImage:nil];
        self.detailLabel.text = item.content;
        self.collectView.item = item;
        [self.groupLabel setTitle:[NSString stringWithFormat:@"# %@",item.topic] forState:UIControlStateNormal];
        self.commendBtn.countLabel.text = [NSString stringWithFormat:@"%@",item.comment_count];
        self.starBtn.countLabel.text = [NSString stringWithFormat:@"%@",item.praise_count];
        self.starBtn.selected = [item.is_praised intValue] == 1 ? YES : NO;
        self.starBtn.countLabel.textColor = self.starBtn.selected == YES ? [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#3D35E1" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]] : [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBCD9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
            self.commendBtn.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBCD9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
        self.starBtn.isFirst = YES;
        [self.starBtn setIconViewSelectedImage:[UIImage imageNamed:@"点赞"] AndUnSelectedImage:[UIImage imageNamed:@"未点赞"]];
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

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == _collectView){
        return self;
    }
    return hitView;
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

// 此处设置各个控件frame
- (void)setCellFrame:(PostTableViewCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    _iconImageView.frame = [cellFrame.iconImageViewFrameValue CGRectValue];
    _nicknameLabel.frame = [cellFrame.nicknameLabelFrameValue CGRectValue];
    _IdentifyBackImage.frame = [cellFrame.IdentifyBackViewFrameValue CGRectValue];
    _timeLabel.frame = [cellFrame.timeLabelFrameValue CGRectValue];
    _funcBtn.frame = [cellFrame.funcBtnFrameValue CGRectValue];
    _detailLabel.frame = [cellFrame.detailLabelFrameValue CGRectValue];
    _collectView.frame = [cellFrame.collectViewFrameValue CGRectValue];
    _groupLabel.frame = [cellFrame.groupLabelFrameValue CGRectValue];
    _starBtn.frame = [cellFrame.starBtnFrameValue CGRectValue];
    _commendBtn.frame = [cellFrame.commendBtnFrameValue CGRectValue];
    _shareBtn.frame = [cellFrame.shareBtnFrameValue CGRectValue];
}
@end
