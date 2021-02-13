//
//  SZHReleaseDynamic.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHReleaseDynamic.h"
#import "SZHReleasView.h"

#define MAX_LIMT_NUM 500  //textview限制输入的最大字数

@interface SZHReleaseDynamic ()<SZHReleaseDelegate,UITextViewDelegate>
@property (nonatomic, strong) SZHReleasView *releaseView;
@end

@implementation SZHReleaseDynamic

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
    } else {
        // Fallback on earlier versions
    }
    
    [self addReleaseView];
    if (self.releaseView.releaseTextView.text.length == 0) {
    self.releaseView.releaseBtn.userInteractionEnabled = NO;
        if (@available(iOS 11.0, *)) {
            self.releaseView.releaseBtn.backgroundColor = [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }else{
        self.releaseView.releaseBtn.userInteractionEnabled = YES;
        self.releaseView.releaseBtn.backgroundColor = [UIColor blueColor];
    }
    // Do any additional setup after loading the view.
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
//计算限制字数
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange offset:0];
    
    //如果有高亮部分，并且字数小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MAX_LIMT_NUM) {
            return YES;
        }else{
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMT_NUM - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                    NSInteger steplen = substring.length;
                    if (idx >= rg.length) {
                        *stop = YES; //取出所需要就break，提高效率
                        return ;
                    }
                    trimString = [trimString stringByAppendingString:substring];
                    
                    idx = idx + steplen;    //使用字串占的长度来作为步长
                }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMT_NUM];
        }
        return NO;
    }
}

//用于显示记述的label
- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange offset:0];
    //如果在变化中是高亮部分，就不计算字符
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > MAX_LIMT_NUM)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMT_NUM];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMT_NUM    - existTextNum),MAX_LIMT_NUM];
    
    //根据编辑文本设置按钮、以及
    if (existTextNum > 0) {
        //不显示提示文字
        [self.releaseView.placeHolderLabel setHidden:YES];
        //设置按钮为可用状态并设置颜色
        self.releaseView.releaseBtn.userInteractionEnabled = NO;
        if (@available(iOS 11.0, *)) {
            self.releaseView.releaseBtn.backgroundColor = [UIColor colorNamed:@"SZH发布动态按钮正常背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }else{
        //显示提示文字
        [self.releaseView.placeHolderLabel setHidden:NO];
        //设置按钮为禁用状态并且设置颜色
        self.releaseView.releaseBtn.userInteractionEnabled = YES;
        if (@available(iOS 11.0, *)) {
            self.releaseView.releaseBtn.backgroundColor =  [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
}

#pragma mark- 添加控件
/// 添加表层的view，其实只包括添加图片按钮以上的内容
- (void)addReleaseView{
    //1.属性设置
    if (_releaseView == nil) {
        _releaseView = [[SZHReleasView alloc] init];
        _releaseView.delegate = self;
        _releaseView.releaseTextView.delegate = self;
        _releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%d/%d",MAX_LIMT_NUM,MAX_LIMT_NUM];
    }
    //2.frame
    [self.view addSubview:self.releaseView];
    self.releaseView.frame = self.view.frame;
}

@end
