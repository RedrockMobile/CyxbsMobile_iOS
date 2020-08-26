//
//  QAAnswerViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAnswerViewController.h"
#import "QAAnswerModel.h"
#import "QAExitView.h"
#import "GKPhotoBrowser.h"


@interface QAAnswerViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(assign,nonatomic)BOOL isFromDraft;

@property(strong,nonatomic)NSNumber *draftId;

@property(strong,nonatomic)QAAnswerModel *model;

/// 问题id
@property(strong,nonatomic)NSNumber *questionId;

@property (nonatomic, weak) UIScrollView *scrollView;

/// 问题描述
@property(copy,nonatomic)NSString *content;

/// 添加图片
@property(strong,nonatomic)NSMutableArray<UIImage *> *answerImageArray;

@property(strong,nonatomic)NSMutableArray<UIImageView *> *answerImageViewArray;

/// 回答内容
@property(strong,nonatomic)UITextView *answerTextView;

/// 退出提示界面
@property(strong,nonatomic)QAExitView *exitView;

@property(strong,nonatomic)SDMask *exitViewMask;

@end


@implementation QAAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)initWithQuestionId:(NSNumber *)questionId content:(NSString *)content answer:(NSString *)answer {
    self = [super init];
    self.title = @"提供帮助";
    self.isFromDraft = NO;
    self.questionId = questionId;
    self.content = content;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNotification];
    self.model = [[QAAnswerModel alloc]init];
    [self setupUI];
    self.answerTextView.text = answer;
    return self;
}
-(void)initFrpmDraft:(NSNumber *)draft_id{
    self.isFromDraft = YES;
    self.draftId = draft_id;
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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TOTAL_TOP_HEIGHT);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:@"问题描述"];
    [titleLabel setAlpha:0.64];
    [titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:15]];
    [scrollView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.scrollView.mas_top).mas_offset(20);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont fontWithName:PingFangSCRegular size: 15];
    contentLabel.text = self.content;
    contentLabel.alpha = 1.0;
    
    [scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(9);
    }];
    
    self.answerTextView = [[UITextView alloc]init];
    //自适应高度
    self.answerTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.answerTextView.placeholder = @"请尽可能给出明确的解决思路哦！";
    self.answerTextView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
    [self.answerTextView setFont:[UIFont fontWithName:PingFangSCRegular size:16]];
    self.answerTextView.layer.cornerRadius = 8;
    self.answerTextView.delegate = self;
    [scrollView addSubview:self.answerTextView];
    [self.answerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(215);
    }];
    
    self.answerImageArray = [NSMutableArray array];
    self.answerImageViewArray = [NSMutableArray array];
    [self setAddImageView];
    
    // 深色模式适配
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"QABackgroundColor"];
        [titleLabel setTextColor:[UIColor colorNamed:@"QANavigationTitleColor"]];
        contentLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        [self.answerTextView setTextColor:[UIColor colorNamed:@"QANavigationTitleColor"]];
        self.answerTextView.placeholderColor = [UIColor colorNamed:@"QATextViewPlaceholderColor"];
        self.answerTextView.backgroundColor = [UIColor colorNamed:@"QATextViewColor"];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        [titleLabel setTextColor: [UIColor colorWithHexString:@"#15315B"]];
        contentLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:0.39];
        [self.answerTextView setTextColor:[UIColor colorWithHexString:@"#15315B"]];
        self.answerTextView.placeholderColor = [UIColor colorWithHexString:@"#15315B"];
        self.answerTextView.backgroundColor = [UIColor colorWithHexString:@"#e8f0fc"];
    }

}

- (void)setAddImageView{
    
    NSInteger count = self.answerImageArray.count;
    // 只有小于等于6张图片的时候才添加”添加按钮“
    if (count + 1 <= 7) {
        
        UIImageView *addImageView = [[UIImageView alloc]init];
        [addImageView setImage:[UIImage imageNamed:@"addImageButton"]];
        addImageView.layer.cornerRadius = 8;
        addImageView.clipsToBounds = YES;
        addImageView.contentMode = UIViewContentModeScaleAspectFill;
        addImageView.userInteractionEnabled = YES;
        
        // 添加点击手势
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
        [addImageView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:addImageView];
        
        NSInteger widthAndHeight = (SCREEN_WIDTH - 60)/3;
        
        // 如果“添加按钮”（其实是个图片）和其他图片总数小于7(0~5张图片)，那么将“添加按钮”加在其他图片后面。
        if (count + 1 < 7) {
            if (count < 3){
                [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * count);
                    make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(10);
                    make.height.width.mas_equalTo(widthAndHeight);
                    make.bottom.equalTo(self.scrollView).offset(-150);
                }];
            } else {
                for (int i = 0; i < 3; i++) {
                    [self.answerImageViewArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * i);
                        make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(10);
                        make.height.width.mas_equalTo(widthAndHeight);
                    }];
                }
                [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * (count - 3));
                    make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                    make.height.width.mas_equalTo(widthAndHeight);
                    make.bottom.equalTo(self.scrollView).offset(-150);
                }];
            }
        } else if (count + 1 == 7) {        // 已经有6张图片了，“添加按钮”就不加在前面的图片后面了，而是直接加在第6张上面
            addImageView.alpha = 0.85;
            [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * 2);
                make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                make.height.width.mas_equalTo(widthAndHeight);
                make.bottom.equalTo(self.scrollView).offset(-150);
            }];
        }
        [self.answerImageViewArray addObject:addImageView];
    }
}
- (void)addImage{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
// 设置可用的媒体类型、默认只包含kUTTypeImage
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

- (void)changeImage:(UITapGestureRecognizer *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *showBigImage = [UIAlertAction actionWithTitle:@"查看大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableArray *photos = [NSMutableArray array];
        NSInteger index = 0;
        
        for (int i = 0; i < self.answerImageArray.count; i++) {
            UIImage *img = self.answerImageArray[i];
            if (((UIImageView *)sender.view).image == img) {
                index = i;
            }
            GKPhoto *photo = [GKPhoto new];
            photo.image = img;
            [photos addObject:photo];
        }
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        [browser showFromVC:self];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [actionSheet dismissViewControllerAnimated:YES completion:^{
            
            UIAlertController *warningAlertController = [UIAlertController alertControllerWithTitle:@"删除图片" message:@"确定要删除图片吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *determineToDelete = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.answerImageArray removeObject:((UIImageView *)(sender.view)).image];
                NSLog(@"%@--%@", self.answerImageArray, self.answerImageViewArray);
                
                // 删除以后，图片需要往前移动。如果ImageArray还剩余6张及以上的图片，view不用移动，只需要将上面的image全部往前移动，else 是ImageView需要移动的情况
                if (self.answerImageArray.count >= 6) {
                    for (int i = 0; i < 6; i++) {
                        self.answerImageViewArray[i].image = self.answerImageArray[i];
                    }
                } else {
                    [self.answerImageViewArray removeObject:(UIImageView *)sender.view];
                    [sender.view removeFromSuperview];
                    // 删除图片以后全部重新约束
                    NSInteger widthAndHeight = (SCREEN_WIDTH - 60)/3;
                    for (int i = 0; i < self.answerImageViewArray.count; i++) {
                        if (i < 3) {        // 前三个图片的约束
                            [self.answerImageViewArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * i);
                                make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(10);
                                make.height.width.mas_equalTo(widthAndHeight);
                            }];
                        } else if (i < 6) { // 4, 5, 6的约束
                            [self.answerImageViewArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * (i - 3));
                                make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                                make.height.width.mas_equalTo(widthAndHeight);
                            }];
                        } else if (i == self.answerImageViewArray.count - 1) {  // 最后一个，是添加按钮。
                            [self.answerImageViewArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * 2);
                                make.top.mas_equalTo(self.answerTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                                make.height.width.mas_equalTo(widthAndHeight);
                            }];
                        }
                        
                        [((UIView *)(self.answerImageViewArray[i])) layoutIfNeeded];
                    }       // for 循环的后括号
                }       // else 的后括号
            }];     // ”确定删除图片“ alertAction 的后括号
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [warningAlertController addAction:determineToDelete];
            [warningAlertController addAction:cancel];
            
            [self presentViewController:warningAlertController animated:YES completion:nil];
        }];  // dismiss alertSheet completion 的后括号
    }];  // ”删除图片“ alertAction 的后括号
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:showBigImage];
    [actionSheet addAction:deleteAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark - =======UIImagePickerControllerDelegate=========

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.answerImageArray addObject:image];
    if (self.answerImageArray.count <= 6) {     // 第6张以后的图片都不显示在界面上，查看大图可以查看
        UIImageView *imgView = [self.answerImageViewArray lastObject];
        [imgView setImage:image];
    
        // 在调用 “setAddImageView” 之前，将当前正在设置的 imageView 的手势方法改成查看大图，并且增加长按删除功能。
        [imgView removeGestureRecognizer:imgView.gestureRecognizers[0]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
        [imgView addGestureRecognizer:tap];
        
        [self setAddImageView];
    }
    
}
// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)commitAnswer{
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
    [self.answerTextView resignFirstResponder];
    if ([self.answerTextView.text isEqualToString:@""]) {
        [self.exitView removeFromSuperview];
        [self.exitViewMask dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (IS_IPHONEX) {
            self.exitView = [[QAExitView alloc]initWithFrame:CGRectMake(60,200, SCREEN_WIDTH - 120, 396)];
        }else{
            self.exitView = [[QAExitView alloc]initWithFrame:CGRectMake(60,120, SCREEN_WIDTH - 120, 396)];
        }
        
        [self.exitView.saveAndExitBtn addTarget:self action:@selector(saveAndExit) forControlEvents:UIControlEventTouchUpInside];
        [self.exitView.continueEditBtn addTarget:self action:@selector(continueEdit) forControlEvents:UIControlEventTouchUpInside];
        self.exitViewMask = [[SDMaskUserView(self.exitView) sdm_showAlertIn:self.view usingBlock:nil] usingAutoDismiss];
        [self.exitViewMask show];
    }
    
    
}
- (void)continueEdit{
    [self.exitViewMask dismiss];
}
- (void)saveAndExit{
    [self.exitView removeFromSuperview];
    [self.exitViewMask dismiss];
    NSString *title = self.answerTextView.text;
    if (self.isFromDraft == NO) {
        [self.model addItemInDraft:title questionId:self.questionId];
    }else{
        [self.model updateItemInDraft:title draftId:self.draftId];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
