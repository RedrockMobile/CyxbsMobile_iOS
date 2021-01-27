//
//  SZHReleaseDynamic.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHReleaseDynamic.h"
#import "SZHReleasView.h"
@interface SZHReleaseDynamic ()<SZHReleaseDelegate,UITextViewDelegate>
@property (nonatomic, strong) SZHReleasView *releaseView;
@end

@implementation SZHReleaseDynamic

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
    } else {
        // Fallback on earlier versions
    }
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view addSubview:self.releaseView];
    self.releaseView.frame = self.view.frame;
}

#pragma mark- Delegate
//MARK:发布动态的view的代理方法
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)releaseDynamic{
    NSLog(@"发布动态");
}

//MARK:UITExteView代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.releaseView.placeHolderLabel setHidden:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];  //键盘的输入模式
    //当输入模式为简体中文时，进行限制字数
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectRange = [textView markedTextRange];
            //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectRange.start offset:0];
            //没有高亮选择的字，就对已经输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 500) {
                //此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 500)];
                textView.text = [toBeString substringWithRange:finalRange];
                /*
                 也可以直接使用以下方法显示最后的文本，但是这样可能会遇到emoji无法正常显示的问题.旧版邮问就有这样的问题
                 textField.text = [toBeString substringToIndex:MastNumber];
                 */
            }
            //如果没有文本就显示提示label,否则不显示
            if (toBeString.length == 0) {
                [self.releaseView.placeHolderLabel setHidden:NO];
            }else{
                [self.releaseView.placeHolderLabel setHidden:YES];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    //中文输入法以外就直接进行统计限制
    else{
        if (toBeString.length > 500) {
            NSRange finalRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 500)];
            textView.text = [toBeString substringWithRange:finalRange];
        }
    }
    //实时统计字数
    self.releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length, 500];
    
    //如果有文字则按钮可以使用，否则就是禁用
    if (toBeString.length > 0) {
        self.releaseView.releaseBtn.enabled = YES;
    }else{
        self.releaseView.releaseBtn.enabled = NO;
    }
    return YES;
}

#pragma mark- getter
- (SZHReleasView *)releaseView{
    if (_releaseView == nil) {
        _releaseView = [[SZHReleasView alloc] init];
        _releaseView.delegate = self;
        _releaseView.releaseTextView.delegate = self;
    }
    return _releaseView;
}

@end
