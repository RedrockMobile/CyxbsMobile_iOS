//
//  DynamicDetailComentTableCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/16.
//  Copyright © 2021 Redrock. All rights reserved.
//
#import <YBImageBrowser.h>  //用来实现图片浏览器的第三方库

#import "DynamicDetailComentTableCell.h"
#import "FunctionBtn.h"
#import "MGDImageCollectionViewCell.h"
#import "DynamicDetailRequestDataModel.h"

#define Pading SCREEN_WIDTH*0.0427
#define Margin 7
#define item_num 3
@interface DynamicDetailComentTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
///头像
@property (nonatomic, strong) UIImageView *iconImageView;
///昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
///时间
@property (nonatomic, strong) UILabel *timeLabel;
/// 展示回复,以及被回复人昵称的labl
@property (nonatomic, strong) UILabel *replyLbl;
///内容
@property (nonatomic, strong) UILabel *detailLabel;

///点赞按钮
@property (nonatomic, strong) FunctionBtn *starBtn;

/// 放置图片的collection'View
@property (nonatomic, strong) UICollectionView *imageCollectionView;

///几级评论的标识
@property (nonatomic, assign) int commentLevel;
///图片浏览器的数据源数组
@property (nonatomic, copy) NSArray *browserImageDataArray;
@property (nonatomic, copy) NSArray *imageDataArray;
@end
@implementation DynamicDetailComentTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentType:(DynamicCommentType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentLevel = type;
    }
    
    return self;
}

#pragma mark- response event
- (void)clickedStar:(FunctionBtn *)sender{
    DynamicDetailRequestDataModel *model = [[DynamicDetailRequestDataModel alloc] init];
    if (sender.selected == YES) {
        sender.selected = NO;
        sender.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = sender.countLabel.text;
        sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        if (@available(iOS 11.0, *)) {
            sender.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBCD9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
        }
    }else{
        sender.selected = YES;
        sender.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = sender.countLabel.text;
        sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        if (@available(iOS 11.0, *)) {
            sender.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#3D35E1" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]];
        }
    }
    [model starCommentWithComent_id:self.dataModel.comment_id Success:^{
        } Failure:^{
        }];
}


#pragma mark- private methonds
//将各个控件添加到屏幕上,设置控件的frame
- (void)buildFrame{
    //头像
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(17 * HScaleRate_SE);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset((self.commentLevel == DynamicCommentType_stair ? 16*WScaleRate_SE : 56*WScaleRate_SE));
        make.width.height.mas_equalTo((self.commentLevel == DynamicCommentType_stair ? 30*WScaleRate_SE : 22*WScaleRate_SE));
    }];
        //设置圆角
    self.iconImageView.layer.cornerRadius =(self.commentLevel == DynamicCommentType_stair ? 15*WScaleRate_SE : 11*WScaleRate_SE);
    
    //昵称
    [self.contentView addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.commentLevel == DynamicCommentType_stair) {
            make.top.equalTo(self.iconImageView);
        }else{
            make.centerY.equalTo(self.iconImageView);
        }
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10 * WScaleRate_SE);
    }];
    
    
    //发布时间
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.nicknameLabel);
    }];
    self.timeLabel.hidden = (self.commentLevel == DynamicCommentType_stair ? NO : YES);
    
    //点赞按钮
    [self.contentView addSubview:self.starBtn];
    [self.starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.04);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.86);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 20.75/20.05);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
    }];
    
    //内容的label
    if (self.commentLevel == DynamicCommentType_stair) {
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(10 * HScaleRate_SE);
            make.left.mas_equalTo(self.nicknameLabel);
        }];
    }else{
        [self.contentView addSubview:self.replyLbl];
        [self.replyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLabel);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(8 * HScaleRate_SE);
            make.height.mas_equalTo(17);
        }];
        
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(27 * HScaleRate_SE);
            make.left.mas_equalTo(self.nicknameLabel);
        }];
    }
    
    
//    //如果是一级评论就展示图片，否则就不展示
    if (self.commentLevel == DynamicCommentType_stair){
        //图片的collectionView
        [self.contentView addSubview:self.imageCollectionView];
        [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_offset(Pading * 13.5/16);
            if (self.dataModel.pics.count > 2) {
                make.left.equalTo(self.contentView).offset(Pading);
            }else{
                make.left.equalTo(self.detailLabel);
            }
            make.width.mas_equalTo(MAIN_SCREEN_W - 2*Pading);
            if(self.imageDataArray.count == 0){
                make.height.mas_equalTo(1);
            }else{
                make.height.mas_equalTo((self.imageDataArray.count-1)/3 * 10*HScaleRate_SE + ((self.imageDataArray.count-1)/3 + 1)* (SCREEN_WIDTH-(2 * Margin + Pading * 2))/item_num);
            }
        }];
    }
    
    //分割线
    [self.contentView addSubview:self.lineLB];
    [self.lineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
    
}

///时间戳转具体日期
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
   NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
   NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
   [formatter setDateFormat:@"YYYY-MM-dd"];
   NSString *timeStr=[formatter stringFromDate:myDate];
   return timeStr;
}

#pragma mark- delegate
//MARK: CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGDImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
   
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageDataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"寂静"]];
    return cell;
}
//设置每个item的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat item_height = (SCREEN_WIDTH-(2 * Margin + Pading * 2))/item_num;
    CGSize size = CGSizeMake(item_height,item_height);
    return size;
}

//MARK: CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0;i < self.dataModel.pics.count; i++) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:self.dataModel.pics[i]];
        [photos addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = photos;
    browser.currentPage = indexPath.row;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
    
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = self.browserImageDataArray;
//    browser.currentPage = indexPath.row;
//    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
//    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
//    [browser show];
}

#pragma mark- setter
- (void)setDataModel:(DynamicDetailCommentTableCellModel *)dataModel{
    if (dataModel){
        _dataModel = dataModel;
        
        //头像框赋值
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.avatar] placeholderImage:[UIImage imageNamed:@"椭圆 9"]];
        
        //昵称
        self.nicknameLabel.text = dataModel.nick_name;
        
        //发布日期
        self.timeLabel.text = [self getDateStringWithTimeStr:dataModel.publish_time];
        
        //内容，根据几级评论设置内容
            //如果是二级评论，对内容进行处理
        if (self.commentLevel == DynamicCommentType_secondLevel) {
            //回复label的内容
            NSString *tampStr = [NSString stringWithFormat:@"回复 %@：",dataModel.from_nickname];
            NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:tampStr];
            //”回复“的文字处理
            NSRange rangeOne = NSMakeRange(0, 2);
            NSMutableDictionary *dicOne = [NSMutableDictionary dictionary];
            dicOne[NSFontAttributeName] = [UIFont fontWithName:PingFangSCMedium size:17 ];
            dicOne[NSForegroundColorAttributeName] = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C57" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
            [attribut addAttributes:dicOne range:rangeOne];
            
            //回复人的昵称的文字处理
            CGFloat detailLength = 3;
            if (dataModel.from_nickname.length >0) {
                NSRange rangetwo = NSMakeRange(3, dataModel.from_nickname.length+1);
                NSMutableDictionary *dictwo  = [NSMutableDictionary dictionary];
                dictwo[NSFontAttributeName] = [UIFont fontWithName:PingFangSCMedium size:13 ];
                dictwo[NSForegroundColorAttributeName] = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#556C89" alpha:1] darkColor:[UIColor colorWithHexString:@"#556C89" alpha:1]];
                [attribut addAttributes:dictwo range:rangetwo];
                detailLength += (dataModel.from_nickname.length+1);
            }
            
//            //回复内容的文字处理
//            NSRange rangethree = NSMakeRange(detailLength, dataModel.content.length);
//            NSMutableDictionary *dicthree = [NSMutableDictionary dictionary];
//            dicthree[NSFontAttributeName] = [UIFont fontWithName:PingFangSCRegular size:15 ];
//            dicthree[NSForegroundColorAttributeName] = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C57" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
//            [attribut addAttributes:dicthree range:rangethree];
            
            self.replyLbl.attributedText = attribut;
            
            //内容的label
            self.detailLabel.text = dataModel.content;
            
        }else{
            //一级评论就直接展示
            self.detailLabel.text = dataModel.content;
        }
        
        //点赞按钮
        self.starBtn.countLabel.text = [NSString stringWithFormat:@"%@",dataModel.praise_count];
        self.starBtn.selected = dataModel.is_praised;
        self.starBtn.countLabel.textColor = self.starBtn.selected == YES ? [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#3D35E1" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]] : [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBCD9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
        [self.starBtn setIconViewSelectedImage:[UIImage imageNamed:@"点赞"] AndUnSelectedImage:[UIImage imageNamed:@"未点赞"]];
        
        self.imageDataArray = dataModel.pics;
        [self buildFrame];
    }
}
#pragma mark- getter
///头像
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

/// 昵称
- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        _nicknameLabel.font = [UIFont fontWithName:PingFangSCMedium size: 13];
        _nicknameLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    }
    return _nicknameLabel;
}

//发布时间
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont fontWithName:PingFangSCMedium size: 11];
        _timeLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#556C89" alpha:1] darkColor:[UIColor colorWithHexString:@"#5A5A5B" alpha:1]];
       
    }
    return _timeLabel;
}

- (UILabel *)replyLbl{
    if (!_replyLbl) {
        _replyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLbl.backgroundColor = [UIColor clearColor];
    }
    return _replyLbl;
}
///内容
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C57" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        // 多行设置
        _detailLabel.numberOfLines = 0;
        //文字宽度为多少时换行
        _detailLabel.preferredMaxLayoutWidth = self.commentLevel == DynamicCommentType_stair ? (MAIN_SCREEN_W - 100*WScaleRate_SE) : (MAIN_SCREEN_W - 130*WScaleRate_SE);
        [_detailLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _detailLabel;
}

///点赞按钮
- (FunctionBtn *)starBtn{
    if (!_starBtn) {
        _starBtn = [[FunctionBtn alloc] init];
        [_starBtn addTarget:self action:@selector(clickedStar:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _starBtn;
}

///分割线
- (UILabel *)lineLB{
    if (!_lineLB) {
        _lineLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 1)];
        _lineLB.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E3E8ED" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
        _lineLB.hidden = (self.commentLevel == DynamicCommentType_secondLevel?YES:NO);
    }
    return _lineLB;
}

- (UICollectionView *)imageCollectionView{
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //每行item的间距
        layout.minimumLineSpacing = 10 * HScaleRate_SE;
        //每列item的间距
        layout.minimumInteritemSpacing = 5 * HScaleRate_SE;
        
        _imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageCollectionView.backgroundColor = [UIColor clearColor];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        [_imageCollectionView registerClass:[MGDImageCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    }
    return _imageCollectionView;

}
@end
