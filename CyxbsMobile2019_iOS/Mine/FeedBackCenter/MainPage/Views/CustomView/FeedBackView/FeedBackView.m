//
//  FeedBackView.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackView.h"
#import "UIView+XYView.h"
@implementation FeedBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor colorNamed:@"#FFFFFF"];
        [self addSubview:self.feedBackMain];
        [self addSubview:self.splitLine];
        [self addSubview:self.heading];
        [self addSubview:self.textCountLbl];
        [self addSubview:self.headingCountLbl];
        [self addSubview:self.splitLine2];
        [self addSubview:self.photoLbl];
        [self addSubview:self.photoCountLbl];
        [self addSubview:self.imageView1];
        [self addSubview:self.imageView2];
        [self addSubview:self.imageView3];
        [self addSubview:self.plusView];
    }
    return self;
}

#pragma mark - getter
- (UITextField *)heading{
    if (!_heading) {
        _heading = [[UITextField alloc]initWithFrame:CGRectMake(18, 20, self.width - 75, 25)];
        _heading.placeholder = @"添加标题";
        _heading.font = [UIFont fontWithName:PingFangSCBold size:18];
        _heading.delegate = self;
        [_heading addTarget:self action:@selector(getlength:) forControlEvents:UIControlEventEditingChanged];
        [_heading setTextColor:[UIColor colorNamed:@"#15315B"]];
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(self.heading, ivar);
        placeholderLabel.textColor = [UIColor colorNamed:@"heading"];
    }
    return _heading;
}

- (UIView *)splitLine{
    if (!_splitLine) {
        _splitLine = [[UIView alloc]initWithFrame:CGRectMake(16, 55, self.width - 32, 1)];
        _splitLine.backgroundColor = [UIColor systemGray5Color];
    }
    return _splitLine;
}

- (UITextView *)feedBackMain{
    if (!_feedBackMain) {
        _feedBackMain = [[UITextView alloc]initWithFrame:CGRectMake(14, 65, self.width - 36, 280)];
        _feedBackMain.delegate = self;
        [_feedBackMain setTextColor:[UIColor colorNamed:@"#15315B"]];
        _feedBackMain.font = [UIFont fontWithName:PingFangSCMedium size:15];
        [_feedBackMain addSubview:self.placeholder];
    }
    return _feedBackMain;
}

- (UILabel *)placeholder{
    if (!_placeholder) {
        _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 200, 30)];
        _placeholder.textColor = [UIColor colorNamed:@"heading"];
        _placeholder.text = @"添加问题描述";
        _placeholder.font = [UIFont fontWithName:PingFangSCMedium size:15];
        
    }
    return _placeholder;
}

- (UILabel *)headingCountLbl{
    if (!_headingCountLbl) {
        _headingCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(315, 25, 15, 17)];
        _headingCountLbl.font = [UIFont fontWithName:PingFangSCMedium size:13];
        _headingCountLbl.textColor = [UIColor colorNamed:@"Count"];
        _headingCountLbl.text = @"0";
    }
    return _headingCountLbl;
}

- (UILabel *)textCountLbl{
    if (!_textCountLbl) {
        _textCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(293, 317, 35, 17)];
        _textCountLbl.font = [UIFont fontWithName:PingFangSCMedium size:12];
        _textCountLbl.textColor = [UIColor colorNamed:@"Count"];
        _textCountLbl.text = @"0/200";
    }
    return _textCountLbl;
}
- (UIView *)splitLine2{
    if (!_splitLine2) {
        _splitLine2 = [[UIView alloc]initWithFrame:CGRectMake(16, 344, self.width - 32, 1)];
        _splitLine2.backgroundColor = [UIColor systemGray5Color];
    }
    return _splitLine2;
}

- (UILabel *)photoLbl{
    if (!_photoLbl) {
        _photoLbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 361, 150, 21)];
        _photoLbl.text = @"相关问题的截图或图片";
        _photoLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _photoLbl.textColor = [UIColor colorNamed:@"photo"];
    }
    return _photoLbl;
}

- (UILabel *)photoCountLbl{
    if (!_photoCountLbl) {
        _photoCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(304, 363, 21, 17)];
        _photoCountLbl.font = [UIFont fontWithName:PingFangSCMedium size:12];
        _photoCountLbl.textColor = [UIColor colorNamed:@"Count"];
        _photoCountLbl.text = @"0/3";
    }
    return _photoCountLbl;
}

- (UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(18, 389, 98, 98)];
    }
    return _imageView1;
}
- (UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(123, 389, 98, 98)];
    }
    return _imageView2;
}
- (UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(227, 389, 98, 98)];
    }
    return _imageView3;
}

- (UIView *)plusView{
    if (!_plusView) {
        _plusView = [[UIView alloc]initWithFrame:CGRectMake(18, 389, 98, 98)];
        UIImageView *iv2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 98, 98)];
        iv2.image = [UIImage imageNamed:@"plusBG"];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(34, 32.5, 30, 30)];
        iv.image = [UIImage imageNamed:@"myplus"];
        [_plusView addSubview:iv2];
        [_plusView addSubview:iv];
        _plusView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(block)];
        [_plusView addGestureRecognizer:tap];
    }
    return _plusView;
}


#pragma mark - 其他方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)getlength:(UITextField *)sender{
    NSLog(@"%lu",(unsigned long)sender.text.length);
    self.headingCountLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)sender.text.length];
}

#pragma mark - textView代理
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length != 0) {
        self.placeholder.hidden = YES;
        self.textCountLbl.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    }
    else{
        self.placeholder.hidden = NO;
        self.textCountLbl.text = @"0/200";
    }
}

- (void)block{
    self.selectPhoto();
}

@end
