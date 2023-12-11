//
//  TitleView.m
//  UITextView高度自适应Demo
//
//  Created by 石子涵 on 2021/9/16.
//
#import <Masonry.h>
#import "ToDoDetailTitleView.h"
@interface ToDoDetailTitleView()<UITextViewDelegate>
/// 无文字时的提示
@property (nonatomic, strong) UILabel *textViewPlaceHolderLbl;
@end
@implementation ToDoDetailTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark- private methonds
- (void)setUI{
    //圆环btn
    [self addSubview:self.cycleBtn];
    [self.cycleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SCREEN_WIDTH * 0.04);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0613, SCREEN_WIDTH * 0.0613));
    }];
    
    //TextView
        //计算高度
    CGFloat height = 0;
    if([self.textView.text isEqualToString:@""]){
        height = [@"textView" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8267, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textView.font} context:nil].size.height;
    }else{
        height = [self.textView.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8267, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textView.font} context:nil].size.height;
    }
        //布局
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cycleBtn.mas_right).offset(SCREEN_WIDTH * 0.04);
        make.top.equalTo(self.cycleBtn);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8267, height));
    }];
    
    self.titleViewSize = CGSizeMake(SCREEN_WIDTH, height + 5);
    
    //如果是已完成状态，则将透明的btn覆盖在UITextView上
    if (self.model.isDone) {
        self.textView.editable = NO;
        [self addSubview:self.clearBtn];
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.textView);
        }];
    }
    
    //texteView的提示文字框
    [self addSubview:self.textViewPlaceHolderLbl];
    [self.textViewPlaceHolderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.textView);
    }];
}
///比较是否过期
- (BOOL)compareIsOverdueWithTimeStr:(NSString *)timeStr{
    if ([self.model.timeStr isEqualToString:@""]) {
        return NO;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月d日HH:mm"];
    long notifyTimeStamp = [formatter dateFromString:timeStr].timeIntervalSince1970;
    long nowTimeStamp = [NSDate date].timeIntervalSince1970;
    if (nowTimeStamp > notifyTimeStamp) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark- eventResponse
- (void)changeBtnStatu{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeStatu)]) {
        [self.delegate changeStatu];
    }
}

- (void)btnClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInvaliePrompt)]) {
        [self.delegate changeInvaliePrompt];
    }
}

#pragma mark- delegate
- (void)textViewDidChange:(UITextView *)textView{
    
    //设置提示文字
    if(textView.text.length > 0){
        self.textViewPlaceHolderLbl.hidden = YES;
    }else{
        self.textViewPlaceHolderLbl.hidden = NO;
    }
    
    //设置自适应高度
    CGSize contraintSize = CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX);
    CGFloat height = [textView sizeThatFits:contraintSize].height;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    self.titleViewSize = CGSizeMake(SCREEN_WIDTH, height + 5);
    self.changeTitleViewHeightBlock(self.titleViewSize.height);
    
    //防止中英文换行
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{
        NSFontAttributeName: textView.font,
        NSForegroundColorAttributeName: textView.textColor,
        NSParagraphStyleAttributeName:paragraphStyle
    };
    textView.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:attributes];
    
    //防止拼音输入时文本直接获取拼音
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];   //获取高亮部分
    if (newText.length > 0) {
        return;
    }
}

///禁止输入时换行
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

#pragma mark- getter & setter
- (void)setModel:(TodoDataModel *)model{
    //1.数据赋值
    _model = model;
    self.textView.text = model.titleStr;
    
    //2.根据todo的状态来进行一个区别划分
    if (model.isDone) {
        self.textView.editable = NO;
        self.textView.alpha = 0.46;
        
        [self.cycleBtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
    }else if([self compareIsOverdueWithTimeStr:model.timeStr]){
        self.textView.textColor = [UIColor redColor];
        
        [self.cycleBtn setBackgroundImage:[UIImage imageNamed:@"ToDo过期圆圈"] forState:UIControlStateNormal];
    }else{
        [self.cycleBtn setBackgroundImage:[UIImage imageNamed:@"未打勾"] forState:UIControlStateNormal];
    }
    
    //3.进行布局
    [self setUI];
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.delegate = self;
        //设置textview的高度与文本高度契合
            //设置textView的文本显示框距离TextView的页边距为0，默认是距离上下各8的页边距
        _textView.textContainerInset = UIEdgeInsetsZero;
            //设置text距离文本输入框的空白填充为0，默认是为5
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.scrollEnabled = NO;
        _textView.font = [UIFont fontWithName:PingFangSCSemibold size:22];
        _textView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return _textView;
}

- (UILabel *)textViewPlaceHolderLbl{
    if (!_textViewPlaceHolderLbl) {
        _textViewPlaceHolderLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _textViewPlaceHolderLbl.alpha = 0.4;
        _textViewPlaceHolderLbl.text = @"请输入标题";
        _textViewPlaceHolderLbl.font = [UIFont fontWithName:PingFangSCMedium size:22];
        _textViewPlaceHolderLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _textViewPlaceHolderLbl.hidden = YES;
    }
    return _textViewPlaceHolderLbl;
}

- (UIButton *)cycleBtn{
    if (!_cycleBtn) {
        _cycleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
      
        [_cycleBtn addTarget:self action:@selector(changeBtnStatu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cycleBtn;
}

- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _clearBtn.backgroundColor = [UIColor clearColor];
        [_clearBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}


@end
