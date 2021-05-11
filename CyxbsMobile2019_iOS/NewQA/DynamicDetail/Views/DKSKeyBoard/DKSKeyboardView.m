//
//  DKSKeyboardView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSKeyboardView.h"
#import "DKSTextView.h"
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

@interface DKSKeyboardView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, assign) CGFloat totalYOffset;
@property (nonatomic, assign) float keyboardHeight; //键盘高度
@property (nonatomic, assign) double keyboardTime; //键盘动画时长
@property (nonatomic, assign) BOOL emojiClick; //点击表情按钮
@property (nonatomic, assign) BOOL moreClick; //点击更多按钮
/**
 *  聊天键盘 上一次的 y 坐标
 */
@property (nonatomic, assign) CGFloat lastChatKeyboardY;
@end

@implementation DKSKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithLightColor:KUIColorFromRGB(0xF1F3F8) DarkColor:KUIColorFromRGB(0x2D2D2D)];
        self.lastChatKeyboardY = self.frame.origin.y;
        
        //监听键盘出现、消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //此通知主要是为了获取点击空白处回收键盘的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
        
        //创建视图
        [self creatView];
    }
    return self;
}

- (void)creatView {
    
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    if (!IS_IPHONEX) {
        //表情按钮
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
        
        //加号按钮
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView.mas_right).offset(viewMargin);
            make.centerY.equalTo(self.textView);
            make.size.mas_equalTo(CGSizeMake(59*WScaleRate_SE, 28*HScaleRate_SE));
        }];
    }else{
        //表情按钮
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
        
        //加号按钮
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
    self.textView.text = @"";
}
#pragma mark ====== 改变输入框大小 ======
- (void)changeFrame:(CGFloat)height {
    
    self.moreBtn.highlighted = (self.textView.text.length >=1?YES:NO);
    
    CGRect frame = self.textView.frame;
    frame.size.height = height;
    self.textView.frame = frame; //改变输入框的frame
    
    //当输入框大小改变时，改变backView的frame
    self.backView.frame = CGRectMake(0, 0, K_Width, height + (viewMargin * 2));
    self.frame = CGRectMake(0,K_Height-self.backView.height-_keyboardHeight, K_Width, self.backView.height);
    //改变更多按钮、表情按钮的位置
    self.emojiBtn.frame = CGRectMake(0,self.backView.height-viewHeight-viewMargin+5, 40, 40);
    self.moreBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+viewMargin, self.backView.height - viewHeight - viewMargin+5, 59, 28);
    
}

#pragma mark ====== 点击空白处，键盘收起时，移动self至底部 ======
- (void)keyboardHide {
    //收起键盘
    [self.textView resignFirstResponder];
    [self removeBottomViewFromSupview];
    [UIView animateWithDuration:0.25 animations:^{
        //设置self的frame到最底部
        self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.height, K_Width, self.backView.height);
        [self updateAssociateTableViewFrame];
    }];
}

#pragma mark ====== 键盘将要出现 ======
- (void)keyboardWillShow:(NSNotification *)notification {
    [self removeBottomViewFromSupview];
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘的高度
    self.keyboardHeight = endFrame.size.height;
    
    //键盘的动画时长
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        self.frame = CGRectMake(0, endFrame.origin.y - self.backView.height, K_Width, self.height);
        [self updateAssociateTableViewFrame];
//        [self.delegate riseReportViewWithY:CGRectGetMaxY(self.frame) AndDictionnary:userInfo];
        
    } completion:nil];
}

#pragma mark ====== 键盘将要消失 ======
- (void)keyboardWillHide:(NSNotification *)notification {
    //如果是弹出了底部视图时
    if (self.moreClick || self.emojiClick) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, K_Height- self.backView.height, K_Width, self.backView.height);
        [self updateAssociateTableViewFrame];
    }];
}
#pragma mark ====== 移除底部视图 ======
- (void)removeBottomViewFromSupview {

    self.moreClick = NO;
    self.emojiClick = NO;
}

#pragma mark ====== 点击发送按钮 ======
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewContentText:)]) {
            [self.delegate textViewContentText:textView.text];
        }
        [self changeFrame:viewHeight];
        textView.text = @"";
        /*这里返回NO，就代表return键值失效，即页面上按下return，
         不会出现换行，如果为yes，则输入页面会换行*/
        return NO;
    }
    return YES;
}
/**
 *  调整关联的表的高度
 */
- (void)updateAssociateTableViewFrame
{
    //表的原来的偏移量
    CGFloat original = _associateTableView.contentOffset.y;
    
    //键盘的y坐标的偏移量
    CGFloat keyboardOffset = self.frame.origin.y - self.lastChatKeyboardY;
    
    //更新表的frame
    _associateTableView.frame = CGRectMake(0,0, self.frame.size.width, self.frame.origin.y);
    
    //表的超出frame的内容高度
    CGFloat tableViewContentDiffer = _associateTableView.contentSize.height - _associateTableView.frame.size.height;
    
    
    //是否键盘的偏移量，超过了表的整个tableViewContentDiffer尺寸
    CGFloat offset = 0;
    if (fabs(tableViewContentDiffer) > fabs(keyboardOffset)) {
        offset = original-keyboardOffset;
    }else {
        offset = tableViewContentDiffer;
    }
    
    if (_associateTableView.contentSize.height +_associateTableView.contentInset.top+_associateTableView.contentInset.bottom> _associateTableView.frame.size.height) {
        _associateTableView.contentOffset = CGPointMake(0, offset);
    }
}
#pragma mark ====== init ======
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
    }
    return _backView;
}

//表情按钮
- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setImage:[UIImage imageNamed:@"组 10"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_emojiBtn];
    }
    return _emojiBtn;
}
- (void)emojiBtn:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonClick:)]) {
        [self.delegate leftButtonClick:self.textView.text];
    }
}
//更多按钮
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
        [self.backView addSubview:_moreBtn];
    }
    return _moreBtn;
}
- (void)moreBtn:(UIButton*)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightButtonClick:)]) {
        [self.delegate rightButtonClick:self.textView.text];
    }
}
- (DKSTextView *)textView {
    if (!_textView) {
        _textView = [[DKSTextView alloc] init];
        _textView.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [_textView textValueDidChanged:^(CGFloat textHeight) {
            [self changeFrame:textHeight];
        }];
        _textView.maxNumberOfLines = 5;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        
        _textView.placeholder = @"说点什么吧，万一火了呢";
        _textView.placeholderColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x94A6C4) DarkColor:KUIColorFromRGB(0x838384)];
        _textView.font = [UIFont fontWithName:PingFangSCMedium size:15];
        [self.backView addSubview:_textView];
    }
    return _textView;
}

#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
