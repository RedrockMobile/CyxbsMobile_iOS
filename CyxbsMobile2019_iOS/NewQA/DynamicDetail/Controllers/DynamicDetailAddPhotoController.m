//
//  DynamicDetailAddPhotoController.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/19.
//  Copyright © 2021 Redrock. All rights reserved.
//
#import <PhotosUI/PhotosUI.h>


//tool
#import "UIImage+Helper.h"
#import "NSDate+Timestamp.h"

//VC
#import "DynamicDetailAddPhotoController.h"

//Views
#import "SZHReleaseTopBarView.h"    //顶部的导航栏view
#import "SZHReleasView.h"
#import "originPhotoView.h"
#import "SZHPhotoImageView.h"
#import "GYYImageChooseCollectionViewCell.h"

//Models
#import "ReleaseDynamicModel.h"

#define MAX_LIMT_NUM 500  //textview限制输入的最大字数
@interface DynamicDetailAddPhotoController ()<SZHReleaseTopBarViewDelegate,UITextViewDelegate,UINavigationBarDelegate,PHPickerViewControllerDelegate,SZHPhotoImageViewDelegate,OriginPhotoViewDelegate,SZHReleaseDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GYYImageChooseCollectionViewCellDelegate>
@property (nonatomic, strong) SZHReleaseTopBarView *topBarView;
@property (nonatomic, strong) SZHReleasView *releaseView;
/// 放置图片的collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

/// 添加图片的btn
@property (nonatomic, strong) UIButton *addPhotoBtn;

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

@implementation DynamicDetailAddPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
   
    //初始化图片和图片框数组
    self.imagesAry = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    self.isSumitOriginPhoto = NO;
    
    
    self.topBarView = [[SZHReleaseTopBarView alloc] init];
    self.topBarView.titleLbl.text = @"评论";
    self.topBarView.delegate = self;
    [self.view addSubview:self.topBarView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT * 0.5);
        make.bottom.equalTo(self.view.mas_top).offset(STATUSBARHEIGHT + NVGBARHEIGHT);
    }];
    [self addReleaseView];
    
    //如果是一级评论就添加图片
    if (self.isFirstCommentLevel == YES) {
        [self addCollectionView];
        [self addOriginView];
    }
    
    self.buttonStateNumber = 1;
    self.clickReleaseDynamicBtnNumber = 0;
    self.releaseView.releaseTextView.text = self.tampComment;
    if (![self.tampComment isEqual:@""]) {
        [self.releaseView.placeHolderLabel setHidden:YES];
        self.topBarView.releaseBtn.userInteractionEnabled = YES;
        self.topBarView.releaseBtn.backgroundColor = [UIColor colorWithHexString:@"#5B63EE" alpha:1];
    }
   
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

//设置点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark- Delegate
//MARK:顶部视图的代理
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
//发布动态
- (void)releaseDynamic{
    //出现正在发送的提示框
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

    hud.labelText = @"正在上传数据...";
    hud.margin = 8;
    [hud setYOffset:-SCREEN_HEIGHT * 0.26];
    hud.labelFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    [hud setColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0]];
    hud.height = SCREEN_WIDTH * 0.3147 * 29/118;
    hud.cornerRadius = hud.frame.size.height * 1/2;
    
    //设置发布按钮禁用
    self.topBarView.releaseBtn.enabled = NO;
    
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.releaseView.releaseTextView.text forKey:@"content"];
    [param setObject:@(self.post_id) forKey:@"post_id"];
    if (self.isFirstCommentLevel != YES) {
        [param setObject:@(self.reply_id) forKey:@"reply_id"];
    }
    
//    [HttpTool.shareTool
//     form:NewQA_POST_QACommentRelease_API
//     type:HttpToolRequestTypePost
//     parameters:param
//     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
//        NSMutableArray *imageNames = [NSMutableArray array];
//        for (int i = 0; i < self.imagesAry.count; i++)  {
//            [imageNames addObject:[NSString stringWithFormat:@"photo%d",i+1]];
//        }
//        for (int i = 0; i < self.imagesAry.count; i++) {
//            UIImage *image = self.imagesAry[i];
//            UIImage *image1 = [image cropEqualScaleImageToSize:image.size isScale:YES];
//            NSData *data = UIImageJPEGRepresentation(image1, 0.8);
//            NSString *fileName = [NSString stringWithFormat:@"%ld.jpeg", [NSDate nowTimestamp]];
//            [body appendPartWithFileData:data name:imageNames[i] fileName:fileName mimeType:@"image/jpeg"];
//        }
//    }
//     progress:nil
//     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
//        [hud hide:YES];
//        if ([object[@"status"] intValue] == 200) {
//            [NewQAHud showHudWith:@"评论成功" AddView:self.view];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else {
//            [hud hide:YES];
//            //设置发布按钮恢复正常
//            self.topBarView.releaseBtn.enabled = YES;
//            [NewQAHud showHudWith:@"评论失败，请检查网络" AddView:self.view];
//        }
//    }
//     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [hud hide:YES];
//        //设置发布按钮恢复正常
//        self.topBarView.releaseBtn.enabled = YES;
//        [NewQAHud showHudWith:@"评论失败，请检查网络" AddView:self.view];
//    }];
    
    HttpClient *client = [HttpClient defaultClient];
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager POST:NewQA_POST_QACommentRelease_API parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSMutableArray *imageNames = [NSMutableArray array];
        for (int i = 0; i < self.imagesAry.count; i++)  {
            [imageNames addObject:[NSString stringWithFormat:@"photo%d",i+1]];
        }
        for (int i = 0; i < self.imagesAry.count; i++) {
            UIImage *image = self.imagesAry[i];
            UIImage *image1 = [image cropEqualScaleImageToSize:image.size isScale:YES];
            NSData *data = UIImageJPEGRepresentation(image1, 0.8);
            NSString *fileName = [NSString stringWithFormat:@"%ld.jpeg", [NSDate nowTimestamp]];
            [formData appendPartWithFileData:data name:imageNames[i] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        if ([responseObject[@"status"] intValue] == 200) {
            [NewQAHud showHudWith:@"评论成功" AddView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [hud hide:YES];
            //设置发布按钮恢复正常
            self.topBarView.releaseBtn.enabled = YES;
            [NewQAHud showHudWith:@"评论失败，请检查网络" AddView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        //设置发布按钮恢复正常
        self.topBarView.releaseBtn.enabled = YES;
        [NewQAHud showHudWith:@"评论失败，请检查网络" AddView:self.view];
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
        self.topBarView.releaseBtn.userInteractionEnabled = YES;
        if (@available(iOS 11.0, *)) {
            self.topBarView.releaseBtn.backgroundColor = [UIColor colorWithHexString:@"#5B63EE" alpha:1];
        } else {
            // Fallback on earlier versions
        }
    }else{
        //显示提示文字
        [self.releaseView.placeHolderLabel setHidden:NO];
        //设置按钮为禁用状态并且设置颜色
        self.topBarView.releaseBtn.userInteractionEnabled = NO;
        if (@available(iOS 11.0, *)) {
            self.topBarView.releaseBtn.backgroundColor =  [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#AEBCD5" alpha:1] darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
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

//MARK:发布view的代理方法
///添加图片
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
        [NewQAHud showHudWith:@"请将系统升级至ios14.0再使用本功能" AddView:self.releaseView];
    }
}

//MARK:原图View的代理方法
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
//MARK: -- GYYImageChooseCollectionViewCellDelegate
- (void)imageDelegateAction:(GYYImageChooseCollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.imagesAry removeObjectAtIndex:indexPath.row];
    [self imageViewsConstraint];
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

//MARK:collectionView的数据源方法
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
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(MAIN_SCREEN_W * 0.296,MAIN_SCREEN_W * 0.296);
}

//MARK:-----------------------collectionView的代理方法-------------------------------------------------
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

#pragma mark- 添加控件
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
- (void)addCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.minimumLineSpacing = 5.5*HScaleRate_SE;      //最小行间距
    layout.minimumInteritemSpacing = 6*WScaleRate_SE;   //最小列间距
    
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

#pragma mark- getter
- (ReleaseDynamicModel *)releaseDynamicModel{
    if (_releaseDynamicModel == nil) {
        _releaseDynamicModel = [[ReleaseDynamicModel alloc] init];
    }
    return _releaseDynamicModel;
}
@end
