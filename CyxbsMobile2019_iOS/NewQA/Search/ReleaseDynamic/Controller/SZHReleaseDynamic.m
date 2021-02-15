//
//  SZHReleaseDynamic.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//
#import <PhotosUI/PhotosUI.h>      //用于使用PHPicker

#import "SZHReleaseDynamic.h"
#import "SZHReleasView.h"
#import "SZHPhotoImageView.h"       //图片框
#import "originPhotoView.h"         //原图的view
#import "SZHCircleLabelView.h"      //标签的view
#define MAX_LIMT_NUM 500  //textview限制输入的最大字数

@interface SZHReleaseDynamic ()<SZHReleaseDelegate,UITextViewDelegate,UINavigationBarDelegate,PHPickerViewControllerDelegate,SZHPhotoImageViewDelegate,OriginPhotoViewDelegate,SZHCircleLabelViewDelegate>
@property (nonatomic, strong) SZHReleasView *releaseView;

/// 从相册中获取到的图片
@property (nonatomic, strong) NSMutableArray <UIImage *>* imagesAry;
@property (nonatomic, strong) NSMutableArray <UIImageView *>*imageViewArray;

///原图view的相关
@property (nonatomic, strong) originPhotoView *originView;
@property int buttonStateNumber;            //用于计数，进行相关操作

///圈子标签相关
@property (nonatomic, strong) SZHCircleLabelView *circleLabelView;
@property (nonatomic, copy) NSString *circleLabelText;  //添加的文本标签
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
    //添加视图控件
    [self addReleaseView];
    [self addOriginView];
    [self addSZHCircleLabelView];
    //初始化图片和图片框数组
    self.imagesAry = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    self.buttonStateNumber = 1;
    
    
    
}

#pragma mark- private methods
/// 添加的图片框的约束
- (void)imageViewsConstraint{
    //如果图片数组为0，则添加按钮以及圈子标签view回到初始的位置
    if (self.imagesAry.count == 0) {
        //添加按钮
        [self.releaseView.addPhotosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.releaseView.releaseTextView.mas_bottom).offset(7);
            make.left.equalTo(self.view).offset(16);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
        }];
        //圈子标签view
        [self.circleLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.releaseView);
            make.top.equalTo(self.releaseView.addPhotosBtn.mas_bottom).offset(MAIN_SCREEN_H * 0.0569);
        }];
        [self.originView setHidden:YES];    //为0时隐藏原图的view
        return;
    }
    
    // 清除之前所有的图片框
    if (self.imageViewArray.count > 0) {
        [self.originView setHidden:NO];     //显示原图的view
        for (int i = 0; i < self.imageViewArray.count; i++) {
            UIImageView *imageView = self.imageViewArray[i];
            [imageView removeFromSuperview];
        }
        [self.imageViewArray removeAllObjects];
    }
    
    //清除图片数组里面大于9的的那些图片
    for (int i = 0; i < self.imagesAry.count; i++){
        if (i > 8) {
            UIImage *image = self.imagesAry[i];
            [self.imagesAry removeObject:image];
        }
    }
    
    //遍历图片数组，创建imageView,并对其进行约束
    for (int i = 0; i < self.imagesAry.count; i++) {
        SZHPhotoImageView *imageView = [[SZHPhotoImageView alloc] init];
        imageView.delegate = self;
        imageView.image = self.imagesAry[i];
        [self.imageViewArray addObject:imageView];
        [self.view addSubview:imageView];
        
        //约束图片框
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset( 15 + i%3 * (6 + MAIN_SCREEN_W * 0.296));
            make.top.equalTo(self.releaseView.releaseTextView.mas_bottom).offset(7 + i/3 * (MAIN_SCREEN_W * 0.296 + 5.5));
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
        }];
    }
    
    //设置添加照片按钮的约束
    [self.releaseView.addPhotosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15 + self.imageViewArray.count%3 * (6 + MAIN_SCREEN_W * 0.296));
        make.top.equalTo(self.releaseView.releaseTextView.mas_bottom).offset(7 + self.imageViewArray.count/3 * (MAIN_SCREEN_W * 0.296 + 5.5));
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
    }];
    
    //设置是否为原图的小视图的约束
    [self.originView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(self.releaseView.releaseTextView.mas_bottom).offset(7 + (self.imageViewArray.count/3 + 1) * (MAIN_SCREEN_W * 0.296 + 5.5) + MAIN_SCREEN_H * 0.018 );
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.134, 14));
    }];
    
    //设置圈子标签的view
    [self.circleLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.releaseView);
        make.top.equalTo(self.originView.mas_bottom).offset(MAIN_SCREEN_H * 0.0569);
    }];
    
    //如果图片框为9时，使添加图片按钮透明度为0,同时更新圈子标签view的约束
    if (self.imagesAry.count == 9) {
        //如果设置为去除的话，程序会崩溃
        self.releaseView.addPhotosBtn.alpha = 0;
        //重新设置原图view的约束
        [self.originView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0427);
            make.top.equalTo(self.releaseView.releaseTextView.mas_bottom).offset(7 + self.imageViewArray.count/3 * (MAIN_SCREEN_W * 0.296 + 5.5) + MAIN_SCREEN_H * 0.018 );
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.134, 14));
        }];
    }else{
        self.releaseView.addPhotosBtn.alpha = 1;
    }
}

#pragma mark- respose events
//设置点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//点击是否选择上传原图
- (void)choseState{
    self.buttonStateNumber++;
    if (self.buttonStateNumber%2 == 0) {
        [self.originView.clickBtn setBackgroundImage:[UIImage imageNamed:@"原图圈圈点击后"] forState:UIControlStateNormal];
    }else{
        [self.originView.clickBtn setBackgroundImage:[UIImage imageNamed:@"原图圈圈"] forState:UIControlStateNormal];
    }
}

#pragma mark- Delegate
//MARK:发布动态的view的代理方法
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 发布动态
 1.如果选择标签，就提示没有选择标签，如果不选择就归类到其他
 2.无网络连接提示无网络连接
 3.
 */
- (void)releaseDynamic{
    NSLog(@"发布动态");
}
//添加图片
- (void)addPhotos{
    //配置PhPickerConfiguration
    if (@available(iOS 14, *)) {
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
        
        //设置当前的选择模式
        //    configuration.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeAutomatic;
        
        //设置最多只能选九张图片 如果设置为0，则是无限制选择。默认为1
        configuration.selectionLimit = 9;
        //设定只能选择图片  //设定为nil的时候图片、livePhoto、视频都可以选择
        configuration.filter = nil;
        
        //设置PHPickerController
        PHPickerViewController *pickerCV = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        pickerCV.delegate = self;       //设置代理
        
        //弹出图片选择器
        [self presentViewController:pickerCV animated:YES completion:nil];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.releaseView animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
        hud.labelText = @"请将系统升级至ios14.0再使用本功能";
        [hud hide:YES afterDelay:1.5];  //延迟1.5秒后消失
    }
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
//用于显示记录的label
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
    self.releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,existTextNum),MAX_LIMT_NUM];
    
    //根据编辑文本设置按钮、以及
    if (existTextNum > 0) {
        //不显示提示文字
        [self.releaseView.placeHolderLabel setHidden:YES];
        //设置按钮为可用状态并设置颜色
        self.releaseView.releaseBtn.enabled = YES;
        if (@available(iOS 11.0, *)) {
            self.releaseView.releaseBtn.backgroundColor = [UIColor colorNamed:@"SZH发布动态按钮正常背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }else{
        //显示提示文字
        [self.releaseView.placeHolderLabel setHidden:NO];
        //设置按钮为禁用状态并且设置颜色
        self.releaseView.releaseBtn.enabled = NO;
        if (@available(iOS 11.0, *)) {
            self.releaseView.releaseBtn.backgroundColor =  [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
}

//MARK:PHPicker代理方法
/// 选择器调用完之后会使用这个方法
/// @param picker 当前使用的图片选择器
/// @param results 选中的图片数组
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    //使图片选择器消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    for (int i = 0; i < results.count; i++) {
        //获取返回的对象
        PHPickerResult *result = results[i];
        //获取图片
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __weak typeof(self) weakSelf = self;
                    //如果图片大于九张，就删除掉前面选择的
                    if (weakSelf.imagesAry.count <= 9) {
                        [weakSelf.imagesAry addObject:(UIImage *)object];
                    }
                    //遍历循环到最后一个时进行图片框的添加约束
                    if (i == results.count - 1) {
                        dispatch_async(dispatch_get_main_queue(),^{
                            [weakSelf imageViewsConstraint];
                        });
                    }
                });
            }
        }];
    }
}

//MARK:图片框的代理方法
- (void)clearPhotoImageView:(UIImageView *)imageView{
    UIImage *image = imageView.image;
    //1.先删除照片组中的照片
    NSMutableArray *array = [self.imagesAry mutableCopy];
    for (UIImage *resultImage in array) {
        if ([resultImage isEqual:image]) {
            [array removeObject:resultImage];
            self.imagesAry = array;
            break;;
        }
    }
//    //2.再移除照片框
    [imageView removeFromSuperview];
    
    //3.重新布局
        //判断添加图片框是否还存在，不存在就创建
    [self imageViewsConstraint];
}

//MARK:圈子标签的代理
- (void)clickACirleBtn:(UIButton *)sender{
    for (UIButton *button in self.circleLabelView.buttonArray) {
        if (button.tag != sender.tag) {
            if (@available(iOS 11.0, *)) {
                button.backgroundColor = [UIColor colorNamed:@"圈子标签按钮未选中时背景颜色"];
//                [button setTintColor:[UIColor colorNamed:@"圈子标签按钮未选中时文本颜色"]];
                [button setTitleColor:[UIColor colorNamed:@"圈子标签按钮未选中时文本颜色"] forState:UIControlStateNormal];
            } else {
                // Fallback on earlier versions
            }
        }else{
            if (@available(iOS 11.0, *)) {
                button.backgroundColor = [UIColor colorNamed:@"圈子标签按钮选中时背景颜色"];
                [button setTitleColor:[UIColor colorNamed:@"圈子标签按钮选中时文本颜色"] forState:UIControlStateNormal];
    
            } else {
                // Fallback on earlier versions
            }
            self.circleLabelText = sender.titleLabel.text;
        }
//        NSLog(@"%@",sender.titleLabel.text);
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
        _releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%d/%d",0,MAX_LIMT_NUM];
    }
    //2.frame
    [self.view addSubview:self.releaseView];
    self.releaseView.frame = self.view.frame;
}
//添加原图view
- (void)addOriginView{
    originPhotoView *originView = [[originPhotoView alloc] init];
    self.originView = originView;
    self.originView.delegate = self;
    [self.releaseView addSubview:originView];
}
//添加标签view
- (void)addSZHCircleLabelView{
    NSArray *titlearray = @[@"校园周边",@"海底捞",@"学习",@"运动",@"兴趣",@"问答",@"其他",@"123"];
    self.circleLabelView = [[SZHCircleLabelView alloc] initWithArrays:titlearray];
    self.circleLabelView.delegate = self;
    [self.releaseView addSubview:self.circleLabelView];
    [self.circleLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.releaseView);
        make.top.equalTo(self.releaseView.addPhotosBtn.mas_bottom).offset(MAIN_SCREEN_H * 0.0569);
    }];
    
}
@end
