//
//  GYYSendCommentImageChooseViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GYYSendCommentImageChooseViewController.h"
#import <PhotosUI/PhotosUI.h>      //用于使用PHPicker

#import "SZHArchiveTool.h"
#import "NewQAHud.h"            //提示框

#import "ReleaseDynamicModel.h"

#import "SZHReleasView.h"
#import "SZHPhotoImageView.h"       //图片框
#import "originPhotoView.h"         //原图的view
#import "GYYImageChooseCollectionViewCell.h"
#import "YBImageBrowser.h"

#define MAX_LIMT_NUM 500  //textview限制输入的最大字数

@interface GYYSendCommentImageChooseViewController ()<UITextViewDelegate,UINavigationBarDelegate,PHPickerViewControllerDelegate,SZHPhotoImageViewDelegate,OriginPhotoViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GYYImageChooseCollectionViewCellDelegate>

@property(nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SZHReleasView *releaseView;

/// 从相册中获取到的图片
@property (nonatomic, strong) NSMutableArray <UIImage *>* imagesAry;
@property (nonatomic, strong) NSMutableArray <UIImageView *>*imageViewArray;

///原图view的相关
@property (nonatomic, strong) originPhotoView *originView;
@property (nonatomic, assign) BOOL isSumitOriginPhoto;      //是否上传原图
@property int buttonStateNumber;            //用于计数，进行相关操作

/// 点击发布按钮相关
//点击发布按钮的次数
@property int clickReleaseDynamicBtnNumber;
@property (nonatomic, strong) ReleaseDynamicModel *releaseDynamicModel;

@end

@implementation GYYSendCommentImageChooseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
    }
    self.title = @"评论";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:23],NSForegroundColorAttributeName:[UIColor colorWithLightColor:KUIColorFromRGB(0x15315B) DarkColor:KUIColorFromRGB(0xf0f0f2)]}];
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithLightColor:KUIColorFromRGB(0xFFFFFF) DarkColor:KUIColorFromRGB(0x000000)]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentHorizontalAlignment:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIImage *sendImage = [UIImage imageNamed:@"发送"];
    self.sendButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(0, 0,sendImage.size.width, sendImage.size.height);
    [self.sendButton setBackgroundImage:sendImage forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[UIColor colorWithLightColor:KUIColorFromRGB(0xffffff) DarkColor:KUIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
    self.sendButton.userInteractionEnabled = NO;
    self.sendButton.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:13];
    [self.sendButton addTarget:self action: @selector(releaseDynamic) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sendButton];
    
    [self addReleaseView];
    [self addScrollView];
    [self addOriginView];
    
    //初始化图片和图片框数组
    self.imagesAry = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    self.isSumitOriginPhoto = NO;
    
    self.buttonStateNumber = 1;
    self.clickReleaseDynamicBtnNumber = 0;
    
    //    //判断是上次退出时是否有草稿，有草稿的话就显示草稿内容
    //    NSString *string1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSaveDrafts"];
    //    if ([string1 isEqualToString:@"yes"]) {
    //        [self showDrafts];
    //    }
    
    self.releaseView.releaseTextView.text = self.tampComment;
    if ([self.releaseView.releaseTextView.text isEqualToString:@""]) {
    }else{
        [self.releaseView.placeHolderLabel setHidden:YES];
        //设置统计字数
        self.releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)self.releaseView.releaseTextView.text.length,MAX_LIMT_NUM];
    }
    
    //请求网络数据并缓存
    [self saveDataFromNet];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesAry.count >=9?9:(self.imagesAry.count+1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYYImageChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.delegate = self;
    
    if (indexPath.row == self.imagesAry.count || self.imagesAry.count == 0) {
        cell.photoImageView.image = [UIImage imageNamed:@""];
        cell.addNewPhotoButton.hidden = NO;
    }else{
        cell.addNewPhotoButton.hidden = YES;
        cell.photoImageView.image = self.imagesAry[indexPath.row];
    }
    
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);//分别为上、左、下、右
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(MAIN_SCREEN_W * 0.296,MAIN_SCREEN_W * 0.296);
}

//这个是两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.5;
}

//两个cell之间的最小间距间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 6;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.imagesAry.count == indexPath.row || self.imagesAry.count == 0) {//去挑选图片
        
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
    
}
#pragma mark -- GYYImageChooseCollectionViewCellDelegate
- (void)imageDelegateAction:(GYYImageChooseCollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.imagesAry removeObjectAtIndex:indexPath.row];
    [self imageViewsConstraint];
}
#pragma mark- private methods
/// 添加的图片框的约束
- (void)imageViewsConstraint{
    
    NSInteger imageCount = (self.imagesAry.count >=9?9:self.imagesAry.count+1);
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.releaseView.mas_bottom);
        make.height.mas_offset(ceilf(imageCount/3.0)*(MAIN_SCREEN_W * 0.296+5.5));
    }];
    
    if (self.imagesAry.count >0) {
        [self.originView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0427);
            make.top.equalTo(self.collectionView.mas_bottom).mas_offset(MAIN_SCREEN_H * 0.018);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.134, 14));
        }];
    }
    [self.originView setHidden:(self.imagesAry.count>0?NO:YES)];    //为0时隐藏原图的view
    [self.collectionView reloadData];
    
}

///网络请求归档处理
- (void)saveDataFromNet{
    //标签
    [self.releaseDynamicModel getAllTopicsSucess:^(NSArray * _Nonnull topicsAry) {
        [SZHArchiveTool saveTopicsAry:topicsAry];
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
    
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.releaseView.releaseTextView.text forKey:@"content"];
    //    [param setObject:userid forKey:@"stuNum"];
    [param setObject:@(self.post_id) forKey:@"post_id"];
    if (self.reply_id >0) {
        [param setObject:@(self.reply_id) forKey:@"reply_id"];
    }
    
    //如果有图片，将图片加入到参数字典中
    if (self.imagesAry.count > 0) {
        NSMutableArray *imageNameAry = [NSMutableArray array];
        for (int i = 0; i < self.imagesAry.count; i++) {
            [imageNameAry addObject:[NSString stringWithFormat:@"photo%d",i+1]];
        }
        //如果上传原图，将图片进行无损压缩
        if (self.isSumitOriginPhoto == YES) {
            for (int i = 0; i < self.imagesAry.count; i++) {
                UIImage *image = self.imagesAry[i];
                NSData *data = UIImagePNGRepresentation(image);
                [param setObject:data forKey:imageNameAry[i]];
            }
        }else{
            //如果不上传原图，将图片进行有损压缩
            for (int i = 0; i < self.imagesAry.count; i++) {
                UIImage *image = self.imagesAry[i];
                NSData *data = UIImageJPEGRepresentation(image, 0.4);
                [param setObject:data forKey:imageNameAry[i]];
            }
        }
    }
    [[HttpClient defaultClient]requestWithPath:@"https://be-prod.redrock.team/magipoke-loop/comment/releaseComment" method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] ==200) {
            [NewQAHud showHudWith:@"发布评论成功" AddView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
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
        self.sendButton.userInteractionEnabled = YES;
//        if (@available(iOS 11.0, *)) {
//            self.sendButton.backgroundColor = [UIColor colorNamed:@"SZH发布动态按钮正常背景颜色"];
//        }
    }else{
        //显示提示文字
        [self.releaseView.placeHolderLabel setHidden:NO];
        //设置按钮为禁用状态并且设置颜色
        self.sendButton.userInteractionEnabled = NO;
//        if (@available(iOS 11.0, *)) {
//            self.sendButton.backgroundColor =  [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
//        }
    }
}

//MARK:PHPicker代理方法
/// 选择器调用完之后会使用这个方法
/// @param picker 当前使用的图片选择器
/// @param results 选中的图片数组
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    //使图片选择器消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 不需要对每一次请求结果进行处理、只需知道什么视乎请求完成
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < results.count; i++) {
        dispatch_group_enter(group);
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
                    }else{
                        [weakSelf.imagesAry removeObjectAtIndex:0];
                        [weakSelf.imagesAry addObject:(UIImage *)object];
                    }
                    dispatch_group_leave(group);
                });
            }
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self imageViewsConstraint];
    });
}

#pragma mark- 添加控件
- (void)addScrollView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.collectionView registerClass:[GYYImageChooseCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.releaseView.mas_bottom);
        make.height.mas_equalTo(MAIN_SCREEN_W * 0.296).priorityLow();
    }];
}
/// 添加表层的view，其实只包括添加图片按钮以上的内容
- (void)addReleaseView{
    //1.属性设置
    if (_releaseView == nil) {
        _releaseView = [[SZHReleasView alloc] init];
//        _releaseView.delegate = self;
        _releaseView.releaseTextView.delegate = self;
        _releaseView.numberOfTextLbl.text = [NSString stringWithFormat:@"%d/%d",0,MAX_LIMT_NUM];
    }
    //2.frame
    [self.view addSubview:self.releaseView];
    self.releaseView.addPhotosBtn.hidden = YES;
    [self.releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).mas_offset(STATUSBARHEIGHT+NVGBARHEIGHT);
        make.height.mas_offset(MAIN_SCREEN_H * 0.1574);
    }];

    
}
//添加原图view
- (void)addOriginView{
    self.originView = [[originPhotoView alloc] init];
    self.originView.delegate = self;
    [self.view addSubview:self.originView];
    self.originView.hidden = YES;
    [self.originView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(MAIN_SCREEN_H * 0.018);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.134, 14));
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


