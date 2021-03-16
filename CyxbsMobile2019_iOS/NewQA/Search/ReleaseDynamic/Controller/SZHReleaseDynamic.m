//
//  SZHReleaseDynamic.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//
#import <PhotosUI/PhotosUI.h>      //用于使用PHPicker

#import "SZHArchiveTool.h"
#import "NewQAHud.h"            //提示框

#import "ReleaseDynamicModel.h"

#import "SZHReleaseDynamic.h"
#import "SZHReleaseTopBarView.h"    //顶部的导航栏view
#import "SZHReleasView.h"
#import "SZHPhotoImageView.h"       //图片框
#import "originPhotoView.h"         //原图的view
#import "SZHCircleLabelView.h"      //标签的view
#define MAX_LIMT_NUM 500  //textview限制输入的最大字数

@interface SZHReleaseDynamic ()<SZHReleaseTopBarViewDelegate,SZHReleaseDelegate,UITextViewDelegate,UINavigationBarDelegate,PHPickerViewControllerDelegate,SZHPhotoImageViewDelegate,OriginPhotoViewDelegate,SZHCircleLabelViewDelegate>
///视图相关
@property (nonatomic, strong) SZHReleaseTopBarView *topBarView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SZHReleasView *releaseView;

/// 从相册中获取到的图片
@property (nonatomic, strong) NSMutableArray <UIImage *>* imagesAry;
@property (nonatomic, strong) NSMutableArray <UIImageView *>*imageViewArray;

///原图view的相关
@property (nonatomic, strong) originPhotoView *originView;
@property (nonatomic, assign) BOOL isSumitOriginPhoto;      //是否上传原图
@property int buttonStateNumber;            //用于计数，进行相关操作

///圈子标签相关
@property (nonatomic, strong) SZHCircleLabelView *circleLabelView;
@property (nonatomic, strong) NSArray *topicAry;
@property (nonatomic, copy) NSString *circleLabelText;  //添加的文本标签

/// 点击发布按钮相关
//点击发布按钮的次数
@property int clickReleaseDynamicBtnNumber;
@property (nonatomic, strong) ReleaseDynamicModel *releaseDynamicModel;
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
    self.topBarView = [[SZHReleaseTopBarView alloc] init];
    self.topBarView.delegate = self;
    [self.view addSubview:self.topBarView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT * 0.5);
        make.bottom.equalTo(self.view.mas_top).offset(STATUSBARHEIGHT + NVGBARHEIGHT);
//        make.height.mas_equalTo(NVGBARHEIGHT);
//        make.bottom.equalTo(self.view).offset(MAIN_SCREEN_H * 0.096);
    }];
    
    [self addScrollView];
    [self addReleaseView];
    [self addOriginView];
    [self addSZHCircleLabelView];
    
    [self.view bringSubviewToFront:self.topBarView];
    
    //初始化图片和图片框数组
    self.imagesAry = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    self.isSumitOriginPhoto = NO;
    self.circleLabelText = @"未添加标签";
    self.buttonStateNumber = 1;
    self.clickReleaseDynamicBtnNumber = 0;
    //判断是上次退出时是否有草稿，有草稿的话就显示草稿内容
    NSString *string1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSaveDrafts"];
    if ([string1 isEqualToString:@"yes"]) {
        [self showDrafts];
    }
    
    //请求网络数据并缓存
    [self saveDataFromNet];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //点属性设置不行，必须用set
//    [self.tabBarController.tabBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
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
//    for (int i = 0; i < self.imagesAry.count; i++){
//        if (i > 8) {
//            UIImage *image = self.imagesAry[i];
//            [self.imagesAry removeObject:image];
//        }
//    }
    
    //遍历图片数组，创建imageView,并对其进行约束
    for (int i = 0; i < self.imagesAry.count; i++) {
        SZHPhotoImageView *imageView = [[SZHPhotoImageView alloc] init];
        imageView.delegate = self;
        imageView.image = self.imagesAry[i];
        [self.imageViewArray addObject:imageView];
        [self.scrollView addSubview:imageView];
        
        //约束图片框
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset( 15 + i%3 * (6 + MAIN_SCREEN_W * 0.296));
            make.top.equalTo(self.releaseView.releaseTextView.mas_bottom).offset(7 + i/3 * (MAIN_SCREEN_W * 0.296 + 5.5));
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
        }];
    }
    
    printf("cnt=%ld,%ld\n",self.imagesAry.count,self.imageViewArray.count);
    
    //设置添加照片按钮的约束
    [self.releaseView.addPhotosBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15 + self.imageViewArray.count%3 * (6 + MAIN_SCREEN_W * 0.296));
        make.top.equalTo(self.releaseView.releaseTextView.mas_bottom).offset(7 + self.imageViewArray.count/3 * (MAIN_SCREEN_W * 0.296 + 5.5));
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
    }];
    
    //设置是否为原图的小视图的约束
    self.originView.hidden = NO;
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

///网络请求归档处理
- (void)saveDataFromNet{
    //标签
    [self.releaseDynamicModel getAllTopicsSucess:^(NSArray * _Nonnull topicsAry) {
        [SZHArchiveTool saveTopicsAry:topicsAry];
    }];
}

/// 网络上传动态
- (void)updateDynamic{

    [self.releaseDynamicModel sumitDynamicDataWithContent:self.releaseView.releaseTextView.text TopicID:self.circleLabelText ImageAry:self.imagesAry IsOriginPhoto:self.isSumitOriginPhoto Sucess:^{
            [NewQAHud showHudWith:@"发布动态成功" AddView:self.view];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
//        [self.navigationController popToRootViewControllerAnimated:YES];
        } Failure:^{
            [NewQAHud showHudWith:@"请检查你的网络设置" AddView:self.releaseView.releaseTextView];
        }];
   
    
}

/// 显示草稿
- (void)showDrafts{
    //异步解压图片
    NSArray *array = [SZHArchiveTool getDraftsImagesAry];
    if (array.count != 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setCenter:self.view.center];
        [hud setCenterY:(MAIN_SCREEN_H * 0.4303)];
        [hud setMode:MBProgressHUDModeIndeterminate];   //设置类型为菊花加载类型
        hud.labelText = @"请稍等";
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSData *data in array) {
                UIImage *image = [UIImage imageWithData:data];
                [self.imagesAry addObject:image];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    [hud hide:YES];
                }];
                [self imageViewsConstraint];
            });
        });
    }
    
    //显示草稿文字
    self.releaseView.releaseTextView.text = [SZHArchiveTool getDraftsStr];
    if ([self.releaseView.releaseTextView.text isEqualToString:@""]) {
    }else{
        [self.releaseView.placeHolderLabel setHidden:YES];
        //设置统计字数
        self.releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)self.releaseView.releaseTextView.text.length,MAX_LIMT_NUM];
        //设置按钮为可用状态并设置颜色
        self.topBarView.releaseBtn.userInteractionEnabled = YES;
        if (@available(iOS 11.0, *)) {
            self.topBarView.releaseBtn.backgroundColor = [UIColor colorNamed:@"SZH发布动态按钮正常背景颜色"];
        } else {
            // Fallback on earlier versions
        }
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
        self.isSumitOriginPhoto = YES;
    }else{
        [self.originView.clickBtn setBackgroundImage:[UIImage imageNamed:@"原图圈圈"] forState:UIControlStateNormal];
        self.isSumitOriginPhoto = NO;
    }
}

#pragma mark- Delegate
//MARK:发布动态的view的代理方法
//如果无内容，返回到邮圈，如果有内容就提示保存
- (void)pop{
    //1.无内容，返回到上个界面
    if ([self.releaseView.releaseTextView.text isEqualToString:@""] && self.imagesAry.count == 0) {
        //跳回到邮圈
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    //2.有内容点击提示保存内容
    else{
        [self.view endEditing:YES];
        //遮罩层
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor blackColor];
        view.userInteractionEnabled = NO;               //设置禁用
        view.alpha = 0.5;
        [self.view addSubview:view];
        
        //警告提示列表 是否需要保存草稿
        UIAlertController *alertCv = [UIAlertController alertControllerWithTitle:@"是否保存草稿" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        //定义警告活动列表的按钮方法
            //草稿归档，发送网络请求，并且回到上一个界面
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [view removeFromSuperview];     //移除遮罩层
            [NewQAHud showHudWith:@"正在保存" AddView:self.view];
            //异步执行归档耗时操作
            NSString *draftStr = self.releaseView.releaseTextView.text;
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableArray *imageDataAry = [NSMutableArray array];
                for (UIImage *image in self.imagesAry) {
                    NSData *data = UIImagePNGRepresentation(image);
                    [imageDataAry addObject:data];
                }
                [SZHArchiveTool saveDraftsImagesAry:imageDataAry];
                [SZHArchiveTool saveDraftsStr:draftStr];
            });
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            //保存有草稿的信号
            NSString *string = @"yes";
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"isSaveDrafts"];
            
        }];
        
            //不保存草稿，清除之前保存的草稿 回到“圈子”界面
        UIAlertAction *noSaveAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [view removeFromSuperview];     //移除遮罩层
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SZHArchiveTool removeDrafts];      //删除之前的草稿缓存
            //保存无草稿的信号
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"isSaveDrafts"];
        }];
        
            //取消
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [view removeFromSuperview];     //移除遮罩层
        }];
        
        //为警告活动列表添加方法
        [alertCv addAction:saveAction];
        [alertCv addAction:noSaveAction];
        [alertCv addAction:cancelAction];
        
        //弹出警告活动列表
        [self presentViewController:alertCv animated:YES completion:nil];
    }
}
/**
 发布动态
 1.如果选择标签，第一次点击提示没有选择标签，如果第二次点击仍不选择就归类到其他
 2.无网络连接提示无网络连接
 3.
 */
- (void)releaseDynamic{
    NSLog(@"发布动态");
    //如果未添加标签，则第一次提示未添加标签，第二次就直接归类到其他
    if ([self.circleLabelText isEqualToString:@"未添加标签"]) {
        self.clickReleaseDynamicBtnNumber++;
        //显示提示
        if (self.clickReleaseDynamicBtnNumber == 1) {
            //显示提示框
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setMode:(MBProgressHUDModeText)];
            hud.labelText = @"未添加标签";
            [hud hide:YES afterDelay:1];    //延迟一秒后消失
        }else{
            self.circleLabelText = @"其他";
            [self updateDynamic];
        }
    }else{
        [self updateDynamic];
    }
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
        configuration.filter = [PHPickerFilter imagesFilter];
        
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
        self.topBarView.releaseBtn.userInteractionEnabled = YES;
        if (@available(iOS 11.0, *)) {
            self.topBarView.releaseBtn.backgroundColor = [UIColor colorNamed:@"SZH发布动态按钮正常背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }else{
        //显示提示文字
        [self.releaseView.placeHolderLabel setHidden:NO];
        //设置按钮为禁用状态并且设置颜色
        self.topBarView.releaseBtn.userInteractionEnabled = NO;
        if (@available(iOS 11.0, *)) {
            self.topBarView.releaseBtn.backgroundColor =  [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
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
                    if (weakSelf.imagesAry.count < 9) {
                        [weakSelf.imagesAry addObject:(UIImage *)object];
                    }
                    //遍历循环到最后一个时进行图片框的添加约束
#pragma waring 不能使用这种写法，因为这里会在进入主线程前异步操作，可能捕获的i变量值为 results.count-1方法先执行，从而导致方法提前被执行
//                    if(i == results.count - 1){
//
//                    }
                    if (self.imagesAry.count == results.count) {
                        [weakSelf imageViewsConstraint];
                    }
                });
            }
        }];
    }
    
}

//MARK:图片框的代理方法
- (void)clearPhotoImageView:(UIImageView *)imageView{
//    UIImage *image = imageView.image;
    //1.先删除照片组中的照片
//    NSMutableArray *array = [self.imagesAry mutableCopy];
    printf("BefCleacnt=%ld,%ld\n",self.imagesAry.count,self.imageViewArray.count);
    [self.imagesAry  removeObject:imageView.image];
    [self.imageViewArray removeObject:imageView];
//    //2.再移除照片框
    printf("Cleacnt=%ld,%ld\n",self.imagesAry.count,self.imageViewArray.count);
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
            self.circleLabelText = [sender.titleLabel.text substringFromIndex:2];
        }
    }
}
#pragma mark- 添加控件
- (void)addScrollView{
    self.scrollView = [[UIScrollView alloc] init];
    if (MAIN_SCREEN_H > 667) {
        self.scrollView.contentSize = CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 1.3);
    }else{
        self.scrollView.contentSize = CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 1.5);
    }
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topBarView.mas_bottom);
    }];
}
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
    [self.scrollView addSubview:self.releaseView];
    self.releaseView.frame = self.view.frame;
//    [self.releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.topView.mas_bottom);
//    }];
}
//添加原图view
- (void)addOriginView{
    originPhotoView *originView = [[originPhotoView alloc] init];
    self.originView = originView;
    self.originView.delegate = self;
    [self.releaseView addSubview:originView];
    self.originView.hidden = YES;
}
//添加标签view
- (void)addSZHCircleLabelView{
    //先从缓存中读取数据，如果缓存中没有则进行网络请求
    self.topicAry = [SZHArchiveTool getTopicsAry];
    if (self.topicAry == nil ) {
        [self.releaseDynamicModel getAllTopicsSucess:^(NSArray * _Nonnull topicsAry) {
            [self.circleLabelView updateViewWithAry:topicsAry];
//            NSLog(@"得到全部标签----%@",topicsAry);
            [SZHArchiveTool saveTopicsAry:topicsAry];
        }];
    }
    
    self.circleLabelView = [[SZHCircleLabelView alloc] initWithArrays:self.topicAry];
    self.circleLabelView.delegate = self;
    [self.scrollView addSubview:self.circleLabelView];
    [self.circleLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.releaseView);
        make.top.equalTo(self.releaseView.addPhotosBtn.mas_bottom).offset(MAIN_SCREEN_H * 0.0569);
    }];
    
}

#pragma mark- getter
- (ReleaseDynamicModel *)releaseDynamicModel{
    if (_releaseDynamicModel == nil) {
        _releaseDynamicModel = [[ReleaseDynamicModel alloc] init];
    }
    return _releaseDynamicModel;
}
@end
