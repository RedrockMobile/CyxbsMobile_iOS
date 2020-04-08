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
@property(strong,nonatomic)QAAnswerModel *model;
//问题id
@property(strong,nonatomic)NSNumber *questionId;
//问题描述
@property(copy,nonatomic)NSString *content;
//添加图片
@property(strong,nonatomic)NSMutableArray *answerImageArray;
@property(strong,nonatomic)NSMutableArray *answerImageViewArray;
//回答内容
@property(strong,nonatomic)UITextView *answerTextView;
//退出提示界面
@property(strong,nonatomic)QAAnswerExitView *exitView;
@property(strong,nonatomic)SDMask *exitViewMask;
@end

@implementation QAAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)initWithQuestionId:(NSNumber *)questionId content:(NSString *)content{
    self = [super init];
    self.title = @"提供帮助";
    self.questionId = questionId;
    self.content = content;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNotification];
    [self setupUI];
    return self;
}
- (void)customNavigationRightButton{
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightButton.superview).offset(STATUSBARHEIGHT);
        make.width.equalTo(@60);
        make.height.equalTo(@44);
    }];
    if (@available(iOS 11.0, *)) {
           [self.rightButton setTitleColor:[UIColor colorNamed:@"QANavigationTitleColor"] forState:UIControlStateNormal];;
       } else {
           [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#15315B"] forState:UIControlStateNormal];
       }
    [self.rightButton setTitle:@"回答" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(commitAnswer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)back {
    [self saveAnswerContent];
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
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:@"问题描述"];
    [titleLabel setAlpha:0.64];
    [titleLabel setTextColor: [UIColor colorWithHexString:@"#15315B"]];
    [titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:15]];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT + 20);
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
    self.answerTextView.placeholder = @"请尽可能给出明确的解决思路哦！";
    self.answerTextView.placeholderColor = UIColor.blackColor;
    self.answerTextView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
    [self.answerTextView setFont:[UIFont fontWithName:PingFangSCRegular size:16]];
    self.answerTextView.delegate = self;
    [self.view addSubview:self.answerTextView];
    [self.answerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(215);
    }];
    
    self.answerImageArray = [NSMutableArray array];
    self.answerImageViewArray = [NSMutableArray array];
    [self setAddImageView];

}

- (void)setAddImageView{
   
    NSInteger count = self.answerImageArray.count;
    if (count + 1 <= 6){
        UIImageView *addImageView = [[UIImageView alloc]init];
        [addImageView setImage:[UIImage imageNamed:@"addImageButton"]];
        addImageView.userInteractionEnabled = YES;
        //    //添加点击手势
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
        [addImageView addGestureRecognizer:tapGesture];
        [self.view addSubview:addImageView];
        
        
        NSInteger widthAndHeight = (SCREEN_WIDTH - 60)/3;
        if (count < 3){
            [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * count);
                make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(10);
                make.height.width.mas_equalTo(widthAndHeight);
                
            }];
        }else{
            [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * (count - 3));
                make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                make.height.width.mas_equalTo(widthAndHeight);
                
            }];
        }
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)saveAnswerContent{

    self.exitView = [[QAAnswerExitView alloc]initWithFrame:CGRectMake(60,200, SCREEN_WIDTH - 120, SCREEN_HEIGHT - 400)];
    [self.exitView.saveAndExitBtn addTarget:self action:@selector(saveAndExit) forControlEvents:UIControlEventTouchUpInside];
    [self.exitView.continueEditBtn addTarget:self action:@selector(continueEdit) forControlEvents:UIControlEventTouchUpInside];
    self.exitViewMask = [[SDMaskUserView(self.exitView) sdm_showAlertIn:self.view usingBlock:nil] usingAutoDismiss];
    [self.exitViewMask show];
    
    
}
- (void)continueEdit{
    [self.exitViewMask dismiss];
}
- (void)saveAndExit{
    [self.exitView removeFromSuperview];
    [self.exitViewMask dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
