//
//  NoteDetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/21.
//  Copyright © 2020 Redrock. All rights reserved.
//显示备忘详情的弹窗view

#import "NoteDetailView.h"

@interface NoteDetailView ()
@property (nonatomic,strong)UILabel *noteTitleLabel;
@property (nonatomic,strong)UIButton *deleteBtn;
@property (nonatomic,strong)UIButton *editBtn;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *weekTextsLabel;
@property (nonatomic,strong)UINavigationController *navc;
@end

@implementation NoteDetailView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNoteTitleLabel];
        [self addDeleteBtn];
        [self addEditBtn];
        [self addWeekTextsLabel];
        [self addDetailLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addNoteTitleLabel{
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    self.noteTitleLabel = label;
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSCBold size:22];
    
    [self.noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.0246*MAIN_SCREEN_W);
    }];
}

- (void)addDeleteBtn{
    UIButton *btn = [self getBtn];
    self.deleteBtn = btn;
    [self addSubview:btn];
    
    if (@available(iOS 11.0, *)) {
        btn.backgroundColor = [UIColor colorNamed:@"230_240_252&45_45_47"];
        [btn setTitleColor:[UIColor colorNamed:@"130_166_218&231_239_251"] forState:UIControlStateNormal];
    } else {
        btn.backgroundColor = [UIColor colorWithRed:230/255.0 green:240/255.0 blue:252/255.0 alpha:1];
        [btn setTitleColor:[UIColor colorWithRed:130/255.0 green:166/255.0 blue:218/255.0 alpha:1] forState:UIControlStateNormal];
    }
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W*0.6133);
        make.top.equalTo(self).offset(0.0295*MAIN_SCREEN_H);
    }];
}

- (void)addEditBtn{
    UIButton *btn = [self getBtn];
    self.editBtn = btn;
    [self addSubview:btn];
    
    if (@available(iOS 11.0, *)) {
        btn.backgroundColor = [UIColor colorNamed:@"enquiryBtnColor"];
        [btn setTitleColor:[UIColor colorNamed:@"white&218_239_251"] forState:UIControlStateNormal];
    } else {
        btn.backgroundColor = [UIColor colorWithRed:69/255.0 green:62/255.0 blue:217/255.0 alpha:1];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W*0.8026);
        make.top.equalTo(self).offset(0.0295*MAIN_SCREEN_H);
    }];
}

- (UIButton*)getBtn{
    UIButton *btn = [[UIButton alloc] init];
    
    btn.layer.cornerRadius = 0.04265*MAIN_SCREEN_W;
    
    [btn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn).offset(MAIN_SCREEN_W*0.033);
        make.right.equalTo(btn).offset(-MAIN_SCREEN_W*0.033);
    }];
    
    btn.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
    [btn.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.1546*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.0853*MAIN_SCREEN_W);
    }];
    
    return btn;
}

- (void)addWeekTextsLabel{
    UILabel *label = [[UILabel alloc] init];
    self.weekTextsLabel = label;
    [self addSubview:label];
    
    label.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSCRegular size: 13];
    label.numberOfLines = 0;
    label.alpha = 0.6;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
        make.right.equalTo(self).offset(-0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(MAIN_SCREEN_H*0.08);
    }];
}

- (void)addDetailLabel{
    UILabel *label = [[UILabel alloc] init];
    self.detailLabel = label;
    [self addSubview:label];
    
    label.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSCMedium size: 15];
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
        make.right.equalTo(self).offset(-0.04*MAIN_SCREEN_W);
        make.top.equalTo(self.weekTextsLabel.mas_bottom).offset(10);
    }];
}

- (void)setDataModel:(NoteDataModel *)dataModel{
    _dataModel = dataModel;
    self.noteTitleLabel.text = dataModel.noteTitleStr;
    self.detailLabel.text = dataModel.noteDetailStr;
    
    NSString *str1 = [dataModel.weeksStrArray firstObject];
    int i,count = (int)dataModel.weeksStrArray.count;
    for (i=1; i<count; i++) {
        str1 = [NSString stringWithFormat:@"%@、%@",str1,dataModel.weeksStrArray[i]];
    }
    
    NSString *weekStr,*lessonStr,*str2;
    weekStr = [dataModel.timeStrDictArray firstObject][@"weekString"];
    lessonStr = [dataModel.timeStrDictArray firstObject][@"lessonString"];
    str2 = [NSString stringWithFormat:@"%@ %@",weekStr,lessonStr];
    count = (int)dataModel.timeStrDictArray.count;
    for (i=1; i<count; i++) {
        weekStr = dataModel.timeStrDictArray[i][@"weekString"];
        lessonStr = dataModel.timeStrDictArray[i][@"lessonString"];
        str2 = [NSString stringWithFormat:@"%@、%@ %@",str2,weekStr,lessonStr];
    }
    self.weekTextsLabel.text = [NSString stringWithFormat:@"%@的\n\n%@",str1,str2];
}

- (void)deleteBtnClicked{
    //调用代理方法，移走弹窗
    [self.delegate hideDetail];
    
   //发送通知，让WYCClassBookViewController调用WYCClassAndRemindDataModel的方法删除备忘
    //然后在重载self.scrollview的所有view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldDeleteNote" object:self.dataModel];
    
}

- (void)editBtnClicked{
    //调用代理方法，移走弹窗
    [self.delegate hideDetail];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DLReminderSetTimeVCShouldEditNote" object:self.dataModel];
    
}
@end
