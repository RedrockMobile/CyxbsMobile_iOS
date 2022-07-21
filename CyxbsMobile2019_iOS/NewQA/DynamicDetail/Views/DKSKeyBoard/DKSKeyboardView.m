//
//  DKSKeyboardView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSKeyboardView.h"
#import "UIView+FrameTool.h"
#import "UITextView+WZB.h"
#import "UIColor+SYColor.h"
//状态栏和导航栏的总高度
#define StatusNav_Height (IS_IPHONEX ? 88 : 64)
//判断是否是iPhoneX
#define IS_IPHONEX (fabs(SCREEN_HEIGHT*0.46193812-SCREEN_WIDTH) < 30)
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height

static float viewMargin = 8.0f; //按钮距离上边距
static float viewHeight = 38.0f; //按钮视图高度

@interface DKSKeyboardView ()

/// 添加图片按钮
@property (nonatomic, strong) UIButton *emojiBtn;


@property (nonatomic, assign) CGFloat totalYOffset;
@property (nonatomic, assign) float keyboardHeight; //键盘高度
@property (nonatomic, assign) double keyboardTime; //键盘动画时长
@property (nonatomic, assign) BOOL emojiClick; //点击表情按钮
@property (nonatomic, assign) BOOL moreClick; //点击更多按钮

@end

@implementation DKSKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithLightColor:KUIColorFromRGB(0xF1F3F8) DarkColor:KUIColorFromRGB(0x2D2D2D)];
        self.originTextViewSize = CGSizeMake(MAIN_SCREEN_W*0.665, viewHeight);
        //创建视图
        [self creatView];
    }
    return self;
}

- (void)creatView {
    //将视图添加到屏幕上
    [self addSubview:self.textView];
    [self addSubview:self.emojiBtn];
    [self addSubview:self.moreBtn];
    
    //布局
    if (IS_IPHONE8) {
        //添加图片按钮
        [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(viewMargin);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20*WScaleRate_SE, 20*WScaleRate_SE));
        }];
        
        //输入视图
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.emojiBtn.mas_right).offset(viewMargin);
            make.centerY.equalTo(self.emojiBtn);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W*0.7, viewHeight));
        }];
        
        //发送按钮
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView.mas_right).offset(viewMargin);
            make.centerY.equalTo(self.textView);
            make.size.mas_equalTo(CGSizeMake(59*WScaleRate_SE, 28*HScaleRate_SE));
        }];
    }else{
        //添加图片按钮
        [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(viewMargin + MAIN_SCREEN_W*0.015);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20*WScaleRate_SE, 20*WScaleRate_SE));
        }];
        
        //输入视图
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.emojiBtn.mas_right).offset(viewMargin+ MAIN_SCREEN_W*0.015);
            make.centerY.equalTo(self.emojiBtn);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W*0.655, viewHeight));
        }];
        
        //发送按钮
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView.mas_right).offset(viewMargin+ MAIN_SCREEN_W*0.015);
            make.centerY.equalTo(self.textView);
            make.size.mas_equalTo(CGSizeMake(59*WScaleRate_SE, 28*HScaleRate_SE));
        }];
    }
  
}
- (void)startInputAction{
    [self.textView becomeFirstResponder];
}
- (void)clearCurrentInput{
    self.textView.text = nil;
}

#pragma mark- response methonds
///代理发送评论
- (void)moreBtn:(UIButton*)sender{
        [self.delegate rightButtonClick:self.textView.text];
}
///代理添加图片
- (void)emojiBtn:(UIButton*)sender{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonClick:)]) {
        [self.delegate leftButtonClick:self.textView.text];
//    }
}



#pragma mark- getter
- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setImage:[UIImage imageNamed:@"组 10"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn;
}
//发送按钮
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_moreBtn setTitle:@"发送" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:13];
        [_moreBtn setTitleColor:[UIColor colorWithLightColor:KUIColorFromRGB(0xFFFFFF) DarkColor:KUIColorFromRGB(0xFFFFFF)] forState:UIControlStateNormal];
        
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"icon_more_nomal"] forState:UIControlStateNormal];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"icon_more_hig"] forState:UIControlStateHighlighted];
        
        [_moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.layer.cornerRadius = 14;
        _moreBtn.layer.masksToBounds = YES;
    }
    return _moreBtn;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _textView.delegate = self;
//        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.scrollEnabled = NO;
       _textView.scrollsToTop = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        //当textview的字符串为0时发送（rerurn）键无效
        _textView.enablesReturnKeyAutomatically = YES;
        
        _textView.placeholder = @"说点什么吧，万一火了呢";
        _textView.placeholderColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x94A6C4) DarkColor:KUIColorFromRGB(0x838384)];
        _textView.font = [UIFont fontWithName:PingFangSCMedium size:15];
        self.maxTextViewheight = ceil(_textView.font.lineHeight * 4 + _textView.contentInset.top + _textView.contentInset.bottom);
    }
    return _textView;
}

@end
