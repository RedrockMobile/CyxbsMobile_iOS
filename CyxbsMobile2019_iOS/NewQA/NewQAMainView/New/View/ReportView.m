//
//  ReportView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ReportView.h"

@interface ReportView()<UITextViewDelegate>

@end

@implementation ReportView
- (instancetype)initWithPostID:(NSNumber *)PostID {
    if ([super init]) {
        self.postID = PostID;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        self.layer.cornerRadius = 9.5;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"请填写举报理由";
        titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 15];
        if (@available(iOS 11.0, *)) {
            titleLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.backgroundColor = [UIColor clearColor];
        textView.textContainerInset = UIEdgeInsetsMake(13.5, 8, 0, 0);
        textView.text = @"150字以内(选填)";
        if (@available(iOS 11.0, *)) {
            textView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#94A6C4" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
            textView.font = [UIFont fontWithName:PingFangSCMedium size:12];
            textView.layer.borderColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]].CGColor;
        } else {
            textView.textColor = [UIColor colorWithRed:12/255.0 green:53/255.0 blue:115/255.0 alpha:1];
        }
        [textView setFont:[UIFont fontWithName:PingFangSCMedium size:12]];
        textView.layer.borderWidth =1.0;
        [self addSubview:textView];
        _textView = textView;
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setBackgroundColor:[UIColor colorWithRed:74.0/255.0 green:67.0/255.0 blue:228.0/255.0 alpha:1]];
        sureBtn.titleLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:255.0/255.0 alpha:1];
        [sureBtn setTitleColor:[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 15];
        [sureBtn addTarget:self action:@selector(ClickedSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        _sureBtn = sureBtn;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        if (@available(iOS 11.0, *)) {
            [cancelBtn setBackgroundColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#C3D4EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:1]]];
        } else {
            // Fallback on earlier versions
        }
        [cancelBtn setTitleColor:[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 15];
        [cancelBtn addTarget:self action:@selector(ClickedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        _cancelBtn = cancelBtn;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.6827 * 21.5/256);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.4023 * 14.5/103);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.6827 * 58/256);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.6827 * 182.5/256);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(SCREEN_WIDTH * 0.6827 * 25.5/256);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.068);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.2466 * 34/92.5);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.2466);
    }];
    _sureBtn.layer.cornerRadius = SCREEN_WIDTH * 0.2466 * 34/92.5 * 1/2;
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(self.sureBtn);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH * 0.0693);
    }];
    _cancelBtn.layer.cornerRadius = _sureBtn.layer.cornerRadius;
}

- (void)ClickedSureBtn {
    if ([self.delegate respondsToSelector:@selector(ClickedSureBtn)]) {
        [self.delegate ClickedSureBtn];
    }
}

- (void)ClickedCancelBtn {
    if ([self.delegate respondsToSelector:@selector(ClickedCancelBtn)]) {
        [self.delegate ClickedCancelBtn];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"150字以内(选填)";
        textView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#94A6C4" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"150字以内(选填)"]){
        textView.text=@"";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@"150字以内(选填)"]) {
        textView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#94A6C4" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    }else {
        textView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#0C3573" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
}
@end
