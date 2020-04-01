//
//  QAAnswerViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAnswerViewController.h"
#import "QAAnswerModel.h"
#import "QAAnswerExitView.h"
@interface QAAnswerViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)NSNumber *questionId;
@property(copy,nonatomic)NSString *content;
@property(strong,nonatomic)NSMutableArray *answerImageArray;
@property(strong,nonatomic)NSMutableArray *answerImageViewArray;
@property(strong,nonatomic)UITextView *answerTextView;
@property(strong,nonatomic)QAAnswerModel *model;
@end

@implementation QAAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(instancetype)initWithQuestionId:(NSNumber *)questionId content:(NSString *)content{
    self = [super init];
    self.questionId = questionId;
    self.content = content;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNotification];
    [self setNavigationBar:@"提供帮助"];
    [self setupUI];
    return self;
}
- (void)setNavigationBar:(NSString *)title{
    //设置标题
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    [label setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NVGBARHEIGHT)];
    label.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 23], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label.alpha = 1.0;
    self.navigationItem.titleView = label;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0 , 0, 60, 60);
    [button setTitle:@"回答" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#15315B"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:23]];
    [button addTarget:self action:@selector(commitAnswer) forControlEvents:UIControlEventTouchUpInside];
    // 设置rightBarButtonItem
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //设置返回按钮样子
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#122D55"];
    
}
- (void)configNavagationBar {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAAnswerCommitSuccess)
                                                 name:@"QAAnswerCommitSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAAnswerCommitFailure)
                                                 name:@"QAAnswerCommitFailure" object:nil];
}

- (void)setupUI{
   
    
    UIView *separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    separateView.alpha = 0.1;
    [self.view addSubview:separateView];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:@"问题描述"];
    [titleLabel setAlpha:0.64];
    [titleLabel setTextColor: [UIColor colorWithHexString:@"#15315B"]];
    [titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:15]];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(separateView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.content attributes:@{NSFontAttributeName: [UIFont fontWithName:PingFangSCRegular size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    
    contentLabel.attributedText = string;
    contentLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    contentLabel.alpha = 1.0;
    
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(9);
    }];
    
    self.answerTextView = [[UITextView alloc]init];
    self.answerTextView.backgroundColor = [UIColor colorWithHexString:@"#e8edfd"];
    [self.answerTextView setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    //自适应高度
    self.answerTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.answerTextView.text = @"请尽可能给出明确的解决思路哦！";
    [self.answerTextView setFont:[UIFont fontWithName:PingFangSCRegular size:16]];
    self.answerTextView.delegate = self;
    [self.view addSubview:self.answerTextView];
    [self.answerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(215);
    }];
    
    UIImageView *addImageView = [[UIImageView alloc]init];
    self.answerImageArray = [NSMutableArray array];
    self.answerImageViewArray = [NSMutableArray array];
    [self.answerImageViewArray addObject:addImageView];
    [addImageView setImage:[UIImage imageNamed:@"addImageButton"]];
    //    [addImageView setImage:self.answerImageViewArray[0]];
    addImageView.userInteractionEnabled = YES;
    //添加点击手势
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
    [addImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:addImageView];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(10);
        make.height.width.mas_equalTo(110);
        
    }];
   
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请尽可能给出明确的解决思路哦！"]) {
        textView.text = @"";
    }
}

- (void)setAddImageView{
   

    if (self.answerImageViewArray.count<3&&self.answerImageViewArray.count>0) {
        
        UIImageView *addImageView = [[UIImageView alloc]init];
        
        [addImageView setImage:[UIImage imageNamed:@"addImageButton"]];
        addImageView.userInteractionEnabled = YES;
        //添加点击手势
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
        [addImageView addGestureRecognizer:tapGesture];
        [self.view addSubview:addImageView];
        NSInteger count = self.answerImageViewArray.count;
       
        [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(20+110*count);
            make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(10);
            make.height.width.mas_equalTo(110);
            
        }];
        [self.answerImageViewArray addObject:addImageView];
        
    }
}
- (void)addImage{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;//编辑模式  但是编辑框是正方形的
    
#// 设置可用的媒体类型、默认只包含kUTTypeImage
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //设置照片来源
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //        // 使用前置还是后置摄像头
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}
#pragma mark - =======UIImagePickerControllerDelegate=========

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.answerImageArray addObject:image];
    UIImageView *imgView = [self.answerImageViewArray lastObject];
    [imgView setImage:image];
    [self setAddImageView];

    //当选择的类型是图片
    
}
// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)commitAnswer{
    self.model = [[QAAnswerModel alloc]init];
    [self.model commitAnswer:self.questionId content:self.answerTextView.text imageArray:self.answerImageArray];

}
- (void)QAAnswerCommitSuccess{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)QAAnswerCommitFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"答案提交失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
    
-(BOOL)navigationShouldPopOnBackButton{
    if (1) {
        // 在这里创建UIAlertController等方法
        [self saveAnswerContent];
        return NO;
    }
    return YES;
}

- (void)saveAnswerContent{
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:997]) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:997] removeFromSuperview];
    }
    //初始化全屏view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor colorWithHexString:@"#DCDDE3"];
    //设置view的tag
    view.tag = 997;
    QAAnswerExitView *exitView = [[QAAnswerExitView alloc]initWithFrame:CGRectMake(60,200, SCREEN_WIDTH - 120, SCREEN_HEIGHT - 400)];
    [exitView.saveAndExitBtn addTarget:self action:@selector(saveAndExit) forControlEvents:UIControlEventTouchUpInside];
    [exitView.continueEditBtn addTarget:self action:@selector(continueEdit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:exitView];
    
    //显示全屏view
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    //    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - 530, SCREEN_WIDTH, 550);
    //    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
    //
    //        [backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 530)];
    //    } completion:nil];
    
    
}
- (void)continueEdit{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:997];
    [view removeFromSuperview];
    
    //    [UIView animateWithDuration:0.4f animations:^{
    //        //        CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 500);
    //    } completion:^(BOOL finished) {
    //        [view removeFromSuperview];
    //    }];
}
- (void)saveAndExit{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:997];
    [view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
