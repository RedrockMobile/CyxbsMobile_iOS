//
//  ToDoDetailRemarkView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/19.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetailRemarkView.h"
@interface ToDoDetailRemarkView()<UITextViewDelegate>
/// 无文字时的提示
@property (nonatomic, strong) UILabel *textViewPlaceHolderLbl;
@end
@implementation ToDoDetailRemarkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLbl.text = @"备注";
        self.botttomDividerView.hidden = YES;
    }
    return self;
}

- (void)buildFrame{
    //计算TextView的高度
    CGFloat height = 0;
    if([self.textView.text isEqualToString:@""]){
        height = [@"textView" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8267, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textView.font} context:nil].size.height;
    }else{
        height = [self.textView.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8267, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textView.font} context:nil].size.height;
    }
    self.remarkViewSize = CGSizeMake(SCREEN_WIDTH * 0.8267, height + SCREEN_HEIGHT*0.0431);
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(SCREEN_HEIGHT * 0.0123);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8267, height));
    }];
    
    //texteView的提示文字框
    [self addSubview:self.textViewPlaceHolderLbl];
    [self.textViewPlaceHolderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.textView);
    }];
}

#pragma mark-UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    //设置提示文字
    if(textView.text.length > 0){
        self.textViewPlaceHolderLbl.hidden = YES;
    }else{
        self.textViewPlaceHolderLbl.hidden = NO;
    }
    
    //设置自适应高度
    [self layoutIfNeeded];
    CGSize contraintSize = CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX);
    CGFloat height = [textView sizeThatFits:contraintSize].height;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    self.remarkViewSize =  CGSizeMake(SCREEN_WIDTH * 0.8267, height + SCREEN_HEIGHT*0.0431);
    self.changeTitleViewHeightBlock(self.remarkViewSize.height);
    
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


#pragma mark- setter && getter
- (void)setModel:(TodoDataModel *)model{
    _model = model;
    self.textView.text = model.detailStr;
    if (model.isDone) {
        self.textView.alpha = 0.46;
        self.textView.editable = NO;
    }
    
    if ([model.detailStr isEqualToString:@""] || model.detailStr == nil) {
        self.textViewPlaceHolderLbl.hidden = NO;
    }else{
        self.textViewPlaceHolderLbl.hidden = YES;
    }
    
    [self buildFrame];
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
        _textView.font = [UIFont fontWithName:PingFangSCSemibold size:15];
        _textView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return _textView;
}

- (UILabel *)textViewPlaceHolderLbl{
    if (!_textViewPlaceHolderLbl) {
        _textViewPlaceHolderLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _textViewPlaceHolderLbl.alpha = 0.4;
        _textViewPlaceHolderLbl.text = @"请输入备注信息";
        _textViewPlaceHolderLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _textViewPlaceHolderLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return _textViewPlaceHolderLbl;
}
@end
