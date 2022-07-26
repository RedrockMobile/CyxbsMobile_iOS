//
//  RemarkTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//  评论页面的cell

#import "RemarkTableViewCell.h"

//动态评论内容
#import "DynamicDetailAddPhotoController.h"

@interface RemarkTableViewCell()

/// 别人对自己的评论的内容label
@property(nonatomic,strong)UILabel * remarkLabel;

/// 自己的评论/动态的内容label
@property(nonatomic,strong)UILabel * contentLabel;

/// 点赞按钮
@property(nonatomic,strong)UIButton *praiseBtn;

/// 评论按钮
@property(nonatomic,strong)UIButton *remarkBtn;

/// 别人对自己的评论的内容label的左边的那个灰色view
@property(nonatomic,strong)UIView *grayTipView;

/// 应该是动态id
@property(nonatomic,copy)NSString *post_id;

/// 应该是评论id
@property(nonatomic,copy)NSString *comment_id;

/// type 为@"1"为动态被评论，为@"2"为评论被评论
@property (nonatomic, copy)NSString *type;

@end

@implementation RemarkTableViewCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addremarkLabel];
        [self addcontentLabel];
        [self addRemarkBtn];
        [self addPraiseBtn];
    }
    return self;
}

//MARK:-添加子控件
//上
- (void)addremarkLabel {
    UILabel *label = [[UILabel alloc] init];
    self.remarkLabel = label;
    [self.contentView addSubview:label];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCRegular size:17];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.188*MAIN_SCREEN_W);
        make.top.equalTo(self.contentView).offset(0.1987*MAIN_SCREEN_W);
        make.right.equalTo(self.contentView).offset(-0.05*SCREEN_WIDTH);
    }];
}
//下
- (void)addcontentLabel {
    UILabel *label = [[UILabel alloc] init];
    self.contentLabel = label;
    [self.contentView addSubview:label];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"85_108_139&131_131_132"];
    } else {
        label.textColor = [UIColor colorWithRed:85/255.0 green:108/255.0 blue:139/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCRegular size:13];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.204*MAIN_SCREEN_W);
        make.top.equalTo(self.contentView).offset(0.2627*MAIN_SCREEN_W);
        make.right.equalTo(self.contentView).offset(-0.05*SCREEN_WIDTH);
    }];
    
    [self addGrayTipView];
}

- (void)addGrayTipView {
    UIView *view = [[UIView alloc] init];
    self.grayTipView = view;
    [self.contentView addSubview:view];
    
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor colorNamed:@"226_232_238&90_90_90"];
    } else {
        view.backgroundColor = [UIColor colorWithRed:226/255.0 green:232/255.0 blue:238/255.0 alpha:1];
    }
    view.layer.cornerRadius = 1.5;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.18*MAIN_SCREEN_W);
        make.centerY.equalTo(self.contentLabel);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(0.0347*SCREEN_WIDTH);
    }];
}

- (void)addPraiseBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.praiseBtn = btn;
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.36*SCREEN_WIDTH);
        make.bottom.equalTo(self.contentView).offset(-0.072*SCREEN_WIDTH);
        make.width.mas_equalTo(0.05426*SCREEN_WIDTH);
        make.height.mas_equalTo(0.05426*SCREEN_WIDTH);
    }];
    
    
    //41/51
    
    [btn addTarget:self action:@selector(praiseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addRemarkBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.remarkBtn = btn;
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.188*SCREEN_WIDTH);
        make.bottom.equalTo(self.contentView).offset(-0.072*SCREEN_WIDTH);
        make.width.mas_equalTo(0.05426*SCREEN_WIDTH);
        make.height.mas_equalTo(0.05426*SCREEN_WIDTH);
    }];
    

    [btn setBackgroundImage:[UIImage imageNamed:@"answerIcon"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

//MARK:-点击按钮后调用的方法
/// 点赞按钮点击后调用
/// 里面有点赞的网络请求操作，为什么没有把网络请求代理给控制器，控制器再用model进行网络请求呢？
/// 因为从模块化的角度来说，这个点赞的操作是完全适合放在cell内部自己解决
- (void)praiseBtnClicked {
//    CCLog(@"%@,%@,%@",self.comment_id,self.type,self.post_id);
//    CCLog(@"mmcon=%@,\tcomID=%@,\tform=%@,\tpoID=%@,\ttype=%@,\tisP=t%@",self.model.content,self.model.comment_id,self.model.from,self.model.post_id,self.model.type,self.model.is_praised);
    self.praiseBtn.enabled = NO;
    if (self.comment_id==nil||self.type==nil) {
        [NewQAHud showHudWith:@"网络错误～" AddView:[[[UIApplication sharedApplication] windows] firstObject]];
        return;
    }
    
    NSDictionary *paramDict = @{
        @"id":self.comment_id,
        @"model":self.type
    };
    
    [[HttpClient defaultClient] requestWithPath:NewQA_POST_QAStar_API method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.praiseBtn.selected) {
            [self changePraiseBtnToState:NO];
            self.model.is_praised = @"0";
        }else {
            [self changePraiseBtnToState:YES];
            self.model.is_praised = @"1";
        }
        self.praiseBtn.enabled = YES;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [NewQAHud showHudWith:@"网络错误～～" AddView:[[[UIApplication sharedApplication] windows] firstObject]];
        self.praiseBtn.enabled = YES;
    }];
}

/// 点击评论按钮后调用
- (void)remarkBtnClicked {
    DynamicDetailAddPhotoController *commentVC = [DynamicDetailAddPhotoController new];
    commentVC.isFirstCommentLevel = NO;
    commentVC.post_id = self.post_id.intValue;
    commentVC.reply_id = self.comment_id.intValue;
    [self.viewController.navigationController pushViewController:commentVC animated:YES];
}

//MARK: - 重写set方法
- (void)setModel:(RemarkParseModel *)model {
    _model = model;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:model.publish_time.doubleValue];
    if ([date isToday]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
        self.timeLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld %ld:%ld",components.year,components.month,components.day,components.hour,components.minute];
    }else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        self.timeLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld",components.year,components.month,components.day];
    }
    
    if (model.nick_name==nil||[model.nick_name isEqualToString:@""]) {
        self.nickNameLabel.text = @"匿名用户";
    }else {
        self.nickNameLabel.text = model.nick_name;
    }
    
    if ([model.type isEqualToString:@"1"]) {
        self.interactionInfoLabel.text = @"评论了你的动态";
    }else {
        self.interactionInfoLabel.text = @"评论了你的评论";
    }
    self.type = model.type;
    
    if (![model.avatar isEqual:@""]&&model.avatar!=nil) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    }
    
    if ([model.is_praised isEqualToString:@"1"]) {
        [self changePraiseBtnToState:YES];
    }else {
        [self changePraiseBtnToState:NO];
    }
    
    self.contentLabel.text = model.from;
    self.remarkLabel.text = model.content;
    self.comment_id = model.comment_id;
    self.post_id = model.post_id;
}


//MARK: - 其他
//用来改变按钮状态
 - (void)changePraiseBtnToState:(BOOL)is {
     self.praiseBtn.selected = is;
     if (is) {
         [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"MinePraiseBtnImg"] forState:UIControlStateNormal];
         [self.praiseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(0.0675*SCREEN_WIDTH);
         }];
     }else {
         [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"MineUnpraiseBtnImg"] forState:UIControlStateNormal];
         [self.praiseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(0.05426*SCREEN_WIDTH);
         }];
     }
 }

@end

