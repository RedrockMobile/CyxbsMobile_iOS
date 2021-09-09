//
//  DynamicSpecificCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <YBImageBrowser.h>  //用来实现图片浏览器的第三方库

//view
#import "DynamicSpecificCell.h"
#import "FunctionBtn.h"         //多功能按钮
#import "FuncView.h"            //点击多功能后弹出来的界面
#import "MGDImageCollectionViewCell.h"
//tool
//#import "UIControl+MGD.h"       //防止按钮多次点击的工具类

#define Pading SCREEN_WIDTH*0.0427
#define Margin 7
#define item_num 3
@interface DynamicSpecificCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
///头像
@property (nonatomic, strong) UIImageView *iconImageView;
///昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
///时间
@property (nonatomic, strong) UILabel *timeLabel;

///内容
@property (nonatomic, strong) UILabel *detailLabel;
///圈子标签按钮
@property (nonatomic, strong) UIButton *groupBtn;
/// 多功能按钮
@property (nonatomic, strong) UIButton *funcBtn;
///点赞
@property (nonatomic, strong) FunctionBtn *starBtn;

///分享
@property (nonatomic, strong) UIButton *shareBtn;
///圈子标签的背景图片
@property (nonatomic, strong) UIImage *groupImage;

@property (nonatomic, strong) UIView *backView;

/// 底部的分割线
@property (nonatomic, strong) UIView *bottomDividerView;

/// 放置图片的collection'View
@property (nonatomic, strong) UICollectionView *imageCollectionView;

@property (nonatomic, copy) NSArray *browserImageDataArray; //图片浏览器的数据源数组
@property (nonatomic, copy) NSArray *imageDataArray;
@property (nonatomic, strong) NSMutableArray <UIImageView *>* imageViewsArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end
@implementation DynamicSpecificCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
    }
    return self;
}

#pragma mark- privata methods

//将各个控件添加到屏幕上,设置控件的frame
- (void)buildFrame{
    //头像
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.0427);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.1066);
    }];
    
    //昵称
    [self addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView).mas_offset(3 * HScaleRate_SE);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(15 * HScaleRate_SE);
    }];
    
    //日期
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.nicknameLabel);
    }];
    
    //多功能按钮
        //如果是自己的动态就先什么都不添加
    if (self.dynamicDataModel.is_self.intValue == 1) {
        
    }else{
        [self addSubview:self.funcBtn];
        [self.funcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.89 * 18/343);
            make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.89);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo((SCREEN_WIDTH * 0.89 * 18/343 + [UIImage imageNamed:@"QAMoreButton"].size.height));
        }];
    }
   
    
    //内容label
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(14.5*HScaleRate_SE);
        make.left.mas_equalTo(self.iconImageView);
        make.width.mas_equalTo(MAIN_SCREEN_W - 2 * Pading);
    }];
    
    //图片的collectionView
    [self addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_detailLabel.mas_bottom).mas_offset(Pading * 13.5/16);
        if (self.dynamicDataModel.pics.count > 2) {
            make.left.equalTo(self).offset(Pading);
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
    
    [self addSubview:self.groupBtn];
    [self.groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCREEN_WIDTH * 0.2707 * 25.5/101.5);
        if (self.imageDataArray.count == 0) {
            make.top.equalTo(self.detailLabel.mas_bottom).offset(SCREEN_HEIGHT * 0.018);
        }else{
            make.top.equalTo(self.imageCollectionView.mas_bottom).offset(SCREEN_HEIGHT * 0.018);
        }
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0413);
    }];
   
    //点赞按钮
    [self addSubview:self.starBtn];
    [self.starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.groupBtn.mas_bottom).mas_offset(SCREEN_WIDTH * 0.5653 * 20.5/212);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 22.75/20.05);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.5587);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
    }];
    
    //评论按钮
    [self addSubview:self.commendBtn];
    [self.commendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.groupBtn.mas_bottom).mas_offset(SCREEN_WIDTH * 0.5653 * 20.5/212);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0535 * 20.75/20.05);
        make.left.mas_equalTo(self.starBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.01);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1648);
    }];
    
    //分享按钮
    [self addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.commendBtn);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0547);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
    }];
    
    //分割线
    [self addSubview:self.bottomDividerView];
    [self.bottomDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.shareBtn.mas_bottom).offset(21.5 * HScaleRate_SE);
        make.height.mas_equalTo(1);
    }];
//
    UILabel *replyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    replyLbl.text = @"回复";
    replyLbl.font = [UIFont fontWithName:PingFangSCSemibold size:18 * fontSizeScaleRate_SE];
    replyLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
    [self addSubview:replyLbl];
    [replyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.top.equalTo(self.bottomDividerView.mas_bottom).offset(25 * HScaleRate_SE);
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
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.browserImageDataArray;
    browser.currentPage = indexPath.row;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}

#pragma mark- setter
- (void)setDynamicDataModel:(DynamicDetailViewModel *)dynamicDataModel{
    if (dynamicDataModel) {
        _dynamicDataModel = dynamicDataModel;
        //对控件进行赋值展示
        //头像
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dynamicDataModel.avatar] placeholderImage:[UIImage imageNamed:@"圈子图像"]];
        //昵称
        self.nicknameLabel.text = dynamicDataModel.nickname;
        //发布日期 这里在赋值的时候进行了一次时间戳的转换
        self.timeLabel.text = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@",dynamicDataModel.publish_time]];
        //内容
        self.detailLabel.text = dynamicDataModel.content;
       
        
        //圈子标签
        [self.groupBtn setTitle:[NSString stringWithFormat:@"# %@",dynamicDataModel.topic] forState:UIControlStateNormal];
        //评论按钮
        self.commendBtn.countLabel.text = [NSString stringWithFormat:@"%@",dynamicDataModel.comment_count];
        self.commendBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        //点赞按钮
        self.starBtn.countLabel.text = [NSString stringWithFormat:@"%@",dynamicDataModel.praise_count];
        self.starBtn.selected = [dynamicDataModel.is_praised intValue] == 1 ? YES : NO;
        self.starBtn.countLabel.textColor = self.starBtn.selected == YES ? [UIColor colorNamed:@"countLabelColor"] : [UIColor colorNamed:@"FuncBtnColor"];
        [self.starBtn setIconViewSelectedImage:[UIImage imageNamed:@"点赞"] AndUnSelectedImage:[UIImage imageNamed:@"未点赞"]];
        
        //图片的设置
            //设置图片浏览器的数据源数组
        NSMutableArray *dataMuteAry = [NSMutableArray array];
        for (int i = 0;i < dynamicDataModel.pics.count; i++) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:dynamicDataModel.pics[i]];
            [dataMuteAry addObject:data];
        }
        self.browserImageDataArray = dataMuteAry;
        self.imageDataArray = dynamicDataModel.pics;
        [self buildFrame];
        [self layoutIfNeeded];
    }
}

#pragma mark- getter
//头像
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //设置圆角
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1066 * 1/2;
    }
    return _iconImageView;
}

//昵称
- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        _nicknameLabel.font = [UIFont fontWithName:PingFangSCSemibold size: 15 ];
        _nicknameLabel.textColor = [UIColor colorNamed:@"CellUserNameColor"];
        
    }
    return _nicknameLabel;
}

//时间
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont fontWithName:PingFangSCMedium size: 11];
        _timeLabel.textColor = [UIColor colorNamed:@"85_108_137"];
    }
    return _timeLabel;
}

//多功能按钮
- (UIButton *)funcBtn{
    if (!_funcBtn) {
        _funcBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _funcBtn.backgroundColor = [UIColor clearColor];
        [_funcBtn setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
        [_funcBtn setImageEdgeInsets:UIEdgeInsetsMake((SCREEN_WIDTH * 0.89 * 18/343 - [UIImage imageNamed:@"QAMoreButton"].size.height), 0, 0, (SCREEN_WIDTH * 0.11 - [UIImage imageNamed:@"QAMoreButton"].size.width))];
        [_funcBtn addTarget:self.delegate action:@selector(clickedFuncBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _funcBtn;
}

///内容
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.textColor = [UIColor colorNamed:@"CellDetailColor"];
        _detailLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        //多行设置
        _detailLabel.numberOfLines = 0;
        _detailLabel.preferredMaxLayoutWidth = MAIN_SCREEN_W - Pading * 2;  //告诉lable在字体多宽的时候换行
    }
    return _detailLabel;
}

///标签
- (UIButton *)groupBtn{
    if (!_groupBtn) {
        _groupBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _groupBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_groupBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_groupBtn).offset(15 * WScaleRate_SE);
            make.right.equalTo(_groupBtn).offset(-15 * WScaleRate_SE);
        }];
        //让按钮的宽度随title字数自适应变宽
        _groupBtn.layer.cornerRadius = SCREEN_WIDTH * 0.2707 * 25.5/101.5 * 1/2;  //设置圆角
        _groupBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_groupBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size: 12.08 * fontSizeScaleRate_SE]];
        [_groupBtn setTitleColor:[UIColor colorNamed:@"CellGroupColor"] forState:UIControlStateNormal];
        _groupBtn.backgroundColor = [UIColor colorNamed:@"CELLTOPICBACKCOLOR"];
//        [_groupBtn addTarget:self.delegate action:@selector(clickedGroupTopicBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupBtn;
}

//点赞
- (FunctionBtn *)starBtn{
    if (!_starBtn) {
        _starBtn = [[FunctionBtn alloc] init];
        [_starBtn addTarget:self.delegate action:@selector(clickedStarBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _starBtn;
}

//评论
- (FunctionBtn *)commendBtn{
    if (!_commendBtn) {
        _commendBtn = [[FunctionBtn alloc] init];
        _commendBtn.iconView.image = [UIImage imageNamed:@"answerIcon"];
        [_commendBtn addTarget:self.delegate action:@selector(clickedCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commendBtn;
}

//分享
- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _shareBtn.backgroundColor = [UIColor clearColor];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self.delegate action:@selector(clickedShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIView *)bottomDividerView{
    if (!_bottomDividerView) {
        _bottomDividerView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomDividerView.backgroundColor = [UIColor colorNamed:@"227_232_237_&52_52_52"];
    }
    return _bottomDividerView;
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



