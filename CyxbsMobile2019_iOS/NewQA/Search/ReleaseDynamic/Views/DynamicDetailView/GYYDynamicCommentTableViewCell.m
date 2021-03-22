//
//  GYYDynamicCommentTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GYYDynamicCommentTableViewCell.h"
#import "MGDImageCollectionViewCell.h"
#import "PostModel.h"
#import "StarPostModel.h"
#import <YBImageBrowser.h>


#define Pading SCREEN_WIDTH*0.0427
#define Margin 4

@interface GYYDynamicCommentTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic,assign) DynamicCommentType commentLevel;//评论级别
@end

@implementation GYYDynamicCommentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentType:(DynamicCommentType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentLevel = type;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"TableViewBackColor"];
        }
        [self BuildUI];
        [self BuildFrame];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)BuildUI {
    ///头像
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    ///昵称
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    _nicknameLabel.font = [UIFont fontWithName:PingFangSCMedium size: 13];
    _nicknameLabel.textColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x15315B) DarkColor:KUIColorFromRGB(0x838384)];
    [self.contentView addSubview:_nicknameLabel];
    
    ///时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont fontWithName:PingFangSCMedium size: 11];
    _timeLabel.textColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x556C89) DarkColor:KUIColorFromRGB(0x5A5A5A)];
  
    [self.contentView addSubview:_timeLabel];
    
    ///内容
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x112C57) DarkColor:KUIColorFromRGB(0xF0F0F0)];
    
    self.detailLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    // 多行设置
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - Pading * 2);
    [self.detailLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:_detailLabel];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectView.backgroundColor = [UIColor clearColor];
    _collectView.delegate=self;
    _collectView.dataSource=self;
    [_collectView registerClass:[MGDImageCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.contentView addSubview:_collectView];
    
    ///点赞
    _starBtn = [[FunctionBtn alloc] init];
    [_starBtn addTarget:self action:@selector(ClickedStar:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_starBtn];
    
}

- (void)BuildFrame {
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_WIDTH * 0.0427);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset((self.commentLevel == DynamicCommentType_stair?16:56));
        make.width.height.mas_equalTo((self.commentLevel == DynamicCommentType_stair?30:22));
    }];
    _iconImageView.layer.cornerRadius =(self.commentLevel == DynamicCommentType_stair?15:11);
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_WIDTH * 0.0427 + 2);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(SCREEN_WIDTH * 0.04);
        make.right.mas_equalTo(self.starBtn.mas_right).mas_offset(-SCREEN_WIDTH * 0.04);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.1381 * 14.5/43.5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nicknameLabel.mas_bottom).mas_offset(9);
        make.left.right.mas_equalTo(self.nicknameLabel);
        make.height.mas_equalTo((self.commentLevel == DynamicCommentType_stair?SCREEN_WIDTH * 0.1794 * 9/56.5:1));
    }];
    
    [_starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.051);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.86);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 20.75/20.05);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
    }];
    
    [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.021);
        make.left.mas_equalTo(self.nicknameLabel);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
    }];
    
    [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_detailLabel.mas_bottom).mas_offset(Pading * 13.5/16);
        make.left.mas_equalTo(_detailLabel);
        make.right.mas_equalTo(self.detailLabel.mas_right).mas_offset(0);
        make.height.mas_equalTo(1).priorityLow();
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-2);
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
- (void)setCommentModle:(GYYDynamicCommentModel *)commentModle{
    _commentModle = commentModle;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModle.avatar] placeholderImage:[UIImage imageNamed:@"椭圆 9"]];
    self.nicknameLabel.text = self.commentModle.nick_name;
    if (self.commentLevel == DynamicCommentType_stair) {
        self.timeLabel.text = [self getDateStringWithTimeStr:self.commentModle.publish_time];
        self.timeLabel.hidden = NO;
    }else{
        self.timeLabel.text = @"";
        self.timeLabel.hidden = YES;
    }
    
    self.timeLabel.hidden = (self.commentLevel == DynamicCommentType_secondLevel?YES:NO);
    
    if (self.commentLevel == DynamicCommentType_secondLevel) {

        NSString *tampStr = [NSString stringWithFormat:@"回复 %@：%@",self.commentModle.from_nickname,self.commentModle.content];
        
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:tampStr];
        NSRange rangeOne = NSMakeRange(0, 2);
        NSMutableDictionary *dicOne = [NSMutableDictionary dictionary];
        dicOne[NSFontAttributeName] = [UIFont fontWithName:PingFangSCMedium size:17];
        dicOne[NSForegroundColorAttributeName] = [UIColor colorWithLightColor:KUIColorFromRGB(0x112C57) DarkColor:KUIColorFromRGB(0xF0F0F0)];
        [attribut addAttributes:dicOne range:rangeOne];
        
        CGFloat detailLength = 3;
        if (self.commentModle.from_nickname.length >0) {
            NSRange rangetwo = NSMakeRange(3, self.commentModle.from_nickname.length+1);
            NSMutableDictionary *dictwo  = [NSMutableDictionary dictionary];
            dictwo[NSFontAttributeName] = [UIFont fontWithName:PingFangSCMedium size:13];
            dictwo[NSForegroundColorAttributeName] = [UIColor colorWithLightColor:KUIColorFromRGB(0x556C89) DarkColor:KUIColorFromRGB(0x556C89)];
            [attribut addAttributes:dictwo range:rangetwo];
            detailLength += (self.commentModle.from_nickname.length+1);
        }
        
        NSRange rangethree = NSMakeRange(detailLength, self.commentModle.content.length);
        NSMutableDictionary *dicthree = [NSMutableDictionary dictionary];
        dicthree[NSFontAttributeName] = [UIFont fontWithName:PingFangSCMedium size:15];
        dicthree[NSForegroundColorAttributeName] = [UIColor colorWithLightColor:KUIColorFromRGB(0x112C57) DarkColor:KUIColorFromRGB(0xF0F0F0)];
        [attribut addAttributes:dicthree range:rangethree];
        
        self.detailLabel.attributedText = attribut;
        
    }else{
        self.detailLabel.text = self.commentModle.content;
    }
    
    
    self.starBtn.countLabel.text = [NSString stringWithFormat:@"%@",self.commentModle.praise_count];
    self.starBtn.selected = self.commentModle.is_praised;
    if (@available(iOS 11.0, *)) {
        self.starBtn.countLabel.textColor = self.starBtn.selected == YES ? [UIColor colorNamed:@"countLabelColor"] : [UIColor colorNamed:@"FuncBtnColor"];
        self.starBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
    }
    [self.starBtn setIconViewSelectedImage:[UIImage imageNamed:@"点赞"] AndUnSelectedImage:[UIImage imageNamed:@"未点赞"]];
    
    [self reloadCell:self.commentModle.pics];
    
}
- (void)reloadCell:(NSArray *)imgarr{
    [self.collectView reloadData];
    [self.collectView layoutIfNeeded];
    [self.collectView setNeedsLayout];
    CGFloat height_pading;
    CGFloat height_collectionview;
    if (imgarr.count == 0) {
        height_pading = 0;
        height_collectionview = 5;
    }else {
        height_pading = 13.5;
        CGFloat item_height = (SCREEN_WIDTH*(1-0.04)-(self.commentLevel == DynamicCommentType_stair?46:78)-Margin*4-16)/3.0;
        height_collectionview = ceil(imgarr.count/3.0)*item_height;
    }
    [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_offset(height_pading);
        make.left.mas_equalTo(_detailLabel);
        make.right.equalTo(self.detailLabel.mas_right);
        make.height.mas_equalTo(height_collectionview);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.commentModle.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGDImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    NSArray *tagsArr = self.commentModle.pics;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:tagsArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"zahnweitu"]];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat item_height = (SCREEN_WIDTH*(1-0.04)-(self.commentLevel == DynamicCommentType_stair?46:78)-Margin*4-16)/3.0;
    return CGSizeMake(item_height, item_height);
}

//这个是两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return Margin*2;
}

//两个cell之间的最小间距间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return Margin;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0;i < [self.commentModle.pics count]; i++) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:self.commentModle.pics[i]];
        [photos addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = photos;
    browser.currentPage = indexPath.row;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}



///时间戳转具体日期
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

/////点赞的逻辑：点赞后，本地改变点赞的数值，然后通过网络请求传入后端
- (void)ClickedStar:(FunctionBtn *)sender {
    
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"id":@(self.commentModle.comment_id),@"model":@"2"};
    [client requestWithPath:NEW_QA_STAR method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue]==200) {
            if (sender.selected == YES) {
                sender.selected = NO;
                sender.iconView.image = [UIImage imageNamed:@"未点赞"];
                NSString *count = sender.countLabel.text;
                sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
                if (@available(iOS 11.0, *)) {
                    sender.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
                }
            }else {
                sender.selected = YES;
                sender.iconView.image = [UIImage imageNamed:@"点赞"];
                NSString *count = sender.countLabel.text;
                sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
                if (@available(iOS 11.0, *)) {
                    sender.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
}

@end

//#import "GYYDynamicCommentTableViewCell.h"
//#import "MGDImageCollectionViewCell.h"
//#import "YBImageBrowser.h"
//

//
//@interface GYYDynamicCommentTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

//@end
//
//@implementation GYYDynamicCommentTableViewCell
//

//- (void)createSubView{
//
//    self.userHead = [[UIImageView alloc]initWithFrame:CGRectZero];
//    self.userHead.image = [UIImage imageNamed:@"椭圆 10"];
//    self.userHead.contentMode = UIViewContentModeScaleAspectFill;
//    [self addSubview:self.userHead];
//    self.userHead.layer.cornerRadius = (self.commentLevel == DynamicCommentType_stair?15:11);
//    self.userHead.layer.masksToBounds = YES;
//
//    self.userName = [[UILabel alloc]initWithFrame:CGRectZero];
//    if (@available(iOS 11.0, *)) {
//        self.userName.textColor = [UIColor colorNamed:@"CellUserNameColor"];
//    }
//    self.userName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//    [self addSubview:self.userName];
//
//    self.timeLB = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.timeLB.textColor = [UIColor colorNamed:@"CellDateColor"];
//    self.timeLB.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
//    [self addSubview:self.timeLB];
//
//    self.contentLB = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.contentLB.textColor = [UIColor colorNamed:@"CellDetailColor"];
//    self.contentLB.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
//    self.contentLB.numberOfLines = 0;
//    [self addSubview:self.contentLB];
//
//    self.likeNumBtn = [[FunctionBtn alloc] init];
//    [self.likeNumBtn addTarget:self action:@selector(ClickedStar:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.likeNumBtn];
//
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    _imagesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//    _imagesCollectionView.backgroundColor = [UIColor clearColor];
//    _imagesCollectionView.delegate=self;
//    _imagesCollectionView.dataSource=self;
//    [_imagesCollectionView registerClass:[MGDImageCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
//    [self addSubview:_imagesCollectionView];
//
//}
//- (void)layoutSubviews{
//
//    [self.userHead mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self.mas_left).mas_offset((self.commentLevel == DynamicCommentType_stair?16:56));
////        make.top.equalTo(self.mas_top).mas_offset((self.commentLevel == DynamicCommentType_stair?25:18));
////        make.height.width.mas_offset((self.commentLevel == DynamicCommentType_stair?30:22));
//        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.0427);
//        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
//        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.1066);
//
//    }];
//    _userHead.layer.cornerRadius = SCREEN_WIDTH * 0.1066 * 1/2;
//
//    [self.likeNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.userHead.mas_centerY);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 20.75/20.05);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
//
//    }];
//
//    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.0427 + 2);
//        make.left.mas_equalTo(self.userHead.mas_right).mas_offset(SCREEN_WIDTH * 0.04);
//        make.right.mas_equalTo(self.likeNumBtn.mas_right).mas_offset(-SCREEN_WIDTH * 0.04);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.1381 * 14.5/43.5);
//    }];
//
//
//
//    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.userName.mas_bottom).mas_offset(9);
//        make.left.right.mas_equalTo(self.userName);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.1794 * 9/56.5);
//    }];
//
//    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.userHead.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.021);
//        make.left.mas_equalTo(self.userHead);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
//    }];
//    [self.imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentLB);
//        make.right.equalTo(self.mas_right).mas_offset(16);
//        make.top.equalTo(self.contentLB.mas_bottom).mas_offset(0);
//        make.height.mas_equalTo(1).priorityLow();
//    }];
//
//}
//- (void)setCommentModle:(GYYDynamicCommentModel *)commentModle{
//    _commentModle = commentModle;
//
//    [self.userHead sd_setImageWithURL:[NSURL URLWithString:self.commentModle.avatar] placeholderImage:[UIImage imageNamed:@"椭圆 9"]];
//    self.userName.text = self.commentModle.nick_name;
//    self.timeLB.text = [self getDateStringWithTimeStr:self.commentModle.publish_time];
//    self.timeLB.hidden = (self.commentLevel != DynamicCommentType_stair ?YES:NO);
//    self.contentLB.text = self.commentModle.content;
//
//    if (self.commentLevel != DynamicCommentType_stair) {
//        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.userName.mas_bottom).mas_offset(9);
//            make.left.right.mas_equalTo(self.userName);
//            make.height.mas_equalTo(1).priorityLow();
//        }];
//    }
//
//    self.likeNumBtn.countLabel.text = [NSString stringWithFormat:@"%@",self.commentModle.praise_count];
//    self.likeNumBtn.selected = self.commentModle.is_praised;
//    if (@available(iOS 11.0, *)) {
//        self.likeNumBtn.countLabel.textColor = self.likeNumBtn.selected == YES ? [UIColor colorNamed:@"countLabelColor"] : [UIColor colorNamed:@"FuncBtnColor"];
//        self.likeNumBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
//    }
//    [self.likeNumBtn setIconViewSelectedImage:[UIImage imageNamed:@"点赞"] AndUnSelectedImage:[UIImage imageNamed:@"未点赞"]];
//
//
//    if (self.commentModle.pics.count >0) {
//
//        [self.imagesCollectionView reloadData];
//        [self.imagesCollectionView layoutIfNeeded];
//        [self.imagesCollectionView setNeedsLayout];
//        CGFloat height_pading;
//        CGFloat height_collectionview;
//        if (self.commentModle.pics.count == 0) {
//            height_pading = 0;
//            height_collectionview = 5;
//        }else {
//            height_pading = 13.5;
//            height_collectionview = self.imagesCollectionView.collectionViewLayout.collectionViewContentSize.height;
//        }
//        [self.imagesCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentLB);
//            make.right.equalTo(self.mas_right).mas_offset(16);
//            make.top.equalTo(self.contentLB.mas_bottom).mas_offset(0);
//            make.height.mas_equalTo(height_collectionview);
//        }];
//
//    }
//
//}
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//
//    return self.commentModle.pics.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    MGDImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
//    NSArray *tagsArr = self.commentModle.pics;
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:tagsArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"zahnweitu"]];
//
//    if (indexPath.row == 2 && tagsArr.count > 3) {
//        unsigned long diff = tagsArr.count - 3;
//        NSString *count = [NSString stringWithFormat:@"+%lu",diff];
//        cell.countLabel.text = count;
//        cell.countLabel.hidden = NO;
//    }
//
//    return cell;
//}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat item_height = (SCREEN_WIDTH-(2 * Margin + PadingLeft+PadingRight))/item_num;
//    CGSize size = CGSizeMake(item_height,item_height);
//    return size;
//}
//
////这个是两行cell之间的最小间距（上下行cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
//
////两个cell之间的最小间距间距（同一行的cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 5;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *photos = [NSMutableArray array];
//    //    for (int i = 0;i < [_item.pics count]; i++) {
//    //        YBIBImageData *data = [YBIBImageData new];
//    //        data.imageURL = [NSURL URLWithString:_item.pics[i]];
//    //        [photos addObject:data];
//    //    }
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = photos;
//    browser.currentPage = indexPath.row;
//    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
//    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
//    [browser show];
//}
//
/////时间戳转具体日期
//- (NSString *)getDateStringWithTimeStr:(NSString *)str{
//    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
//    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *timeStr=[formatter stringFromDate:myDate];
//    return timeStr;
//}
/////点赞的逻辑：点赞后，本地改变点赞的数值，然后通过网络请求传入后端
//- (void)ClickedStar:(FunctionBtn *)sender {
//
//    if (sender.selected == YES) {
//        sender.selected = NO;
//        sender.iconView.image = [UIImage imageNamed:@"未点赞"];
//        NSString *count = sender.countLabel.text;
//        sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
//        if (@available(iOS 11.0, *)) {
//            sender.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
//        } else {
//            // Fallback on earlier versions
//        }
//    }else {
//        sender.selected = YES;
//        sender.iconView.image = [UIImage imageNamed:@"点赞"];
//        NSString *count = sender.countLabel.text;
//        sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
//        if (@available(iOS 11.0, *)) {
//            sender.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
//
//        } else {
//            // Fallback on earlier versions
//        }
//
//    }
//    //点赞评论
//    NSDictionary *param = @{@"id":@(self.commentModle.comment_id),@"model":@"2"};
//    [[HttpClient defaultClient] requestWithPath:NEW_QA_STAR method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"已点赞");
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
//
//}
//
//@end

@interface GYYDynamicCommentView()

@property (nonatomic, strong) UITextView *textView;

/// 左边返回的button
@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UILabel *titleLbl;        //中间的label

/// 顶部的分割条
@property (nonatomic, strong)UIView *topSeparationView;
@end
@implementation GYYDynamicCommentView
- (instancetype)init{
    self = [super init];
    if (self) {
        //设置背景颜色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
        } else {
            // Fallback on earlier versions
        }
        //添加控件
        //        [self addTopBarView];
        [self addTextView];
        [self addAddPhotosBtn];
    }
    return self;
}


#pragma mark- 设置各种控件
/// 添加顶部的bar的视图控件：包括左边返回按钮、中间标题，右边发布按钮
- (void)addTopBarView{
    //左边的按钮
    //1.属性设置
    if (_leftBtn == nil) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"返回的小箭头"] forState:UIControlStateNormal];
        //让代理跳回到上一个界面
        [_leftBtn addTarget:self.delegate action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    //2.frame
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
        //        make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0572);
        //        make.top.equalTo(self);
        //        make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0286);
        make.bottom.equalTo(self.mas_top).offset(NVGBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    
    //标题label
    //1.属性
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"发布动态";
        _titleLbl.font = [UIFont fontWithName:PingFangSCSemibold size:21];
        if (@available(iOS 11.0, *)) {
            _titleLbl.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.leftBtn);
        make.height.mas_equalTo(20);
    }];
    
    //发布按钮
    //1.属性设置
    if (_releaseBtn == nil) {
        _releaseBtn = [[UIButton alloc] init];
        //最开始设置禁用
        _releaseBtn.userInteractionEnabled = NO;
        [_releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_releaseBtn setTitle:@"发布" forState:UIControlStateDisabled];
        _releaseBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:13];
        [_releaseBtn addTarget:self.delegate action:@selector(releaseDynamic) forControlEvents:UIControlEventTouchUpInside];
        _releaseBtn.layer.cornerRadius = MAIN_SCREEN_W * 0.0411;
        if (@available(iOS 11.0, *)) {
            self.releaseBtn.backgroundColor =  [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self addSubview:self.releaseBtn];
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.right.equalTo(self).offset(-MAIN_SCREEN_W *0.0413);
        make.size.mas_equalTo(CGSizeMake(59, 28));
    }];
    
    //底部的分割条
    //1.属性设置
    if (_topSeparationView == nil) {
        _topSeparationView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _topSeparationView.backgroundColor = [UIColor colorNamed:@"SZH分割条颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self addSubview:self.topSeparationView];
    [self.topSeparationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.018);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
}

/// 添加文本内容：包括TextView、placeholde的label、记录字数的label
- (void)addTextView{
    //textView
    //1.属性设置
    if (_releaseTextView == nil) {
        _releaseTextView = [[UITextView alloc] init];
        _releaseTextView.font = [UIFont fontWithName:PingFangSCBold size:16];
        if (@available(iOS 11.0, *)) {
            _releaseTextView.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
            _releaseTextView.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self addSubview:self.releaseTextView];
    [self.releaseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.1574));
    }];
    
    //placeHolder
    //1.属性设置
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"分享你的新鲜事～";
        _placeHolderLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
        if (@available(iOS 11.0, *)) {
            _placeHolderLabel.textColor = [UIColor colorNamed:@"SZH发布动态提示文字颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self.releaseTextView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.releaseTextView).offset(MAIN_SCREEN_W * 0.0413);
        make.top.equalTo(self.releaseTextView).offset(MAIN_SCREEN_H * 0.0225);
        make.height.mas_equalTo(15.5);
    }];
    
    //记录字数的label
    //1.属性设置
    if (_numberOfTextLbl == nil) {
        _numberOfTextLbl = [[UILabel alloc] init];
        _numberOfTextLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.92];
        if (@available(iOS 11.0, *)) {
            _numberOfTextLbl.textColor = [UIColor colorNamed:@"SZHHistoryCellLblColor"];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self addSubview:self.numberOfTextLbl];
    [self.numberOfTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.releaseTextView);
        make.right.equalTo(self).offset(-MAIN_SCREEN_W *0.0413);
        make.height.mas_equalTo(11);
    }];
}

/// 添加照片的按钮
- (void)addAddPhotosBtn{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"添加图片背景"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button addTarget:self.delegate action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseTextView.mas_bottom).offset(7);
        make.left.equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
    }];
    
    //添加中心的小图片框
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"相机"];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button.mas_centerX);
        make.bottom.equalTo(button.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    //下方的label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"添加图片";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"SZH发布动态提示文字颜色"];
    } else {
        // Fallback on earlier versions
    }
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(13.5);
        make.height.mas_equalTo(11.5);
    }];
    
    self.addPhotosBtn = button;
    
}

@end
