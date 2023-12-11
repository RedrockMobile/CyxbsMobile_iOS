//
//  EditMyInfoViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "EditMyInfoContentView.h"
#import "EditMyInfoPresenter.h"
#import "MineViewController.h"
#import "UserInformationIntorductionView.h"

@interface EditMyInfoViewController ()
<
EditMyInfoContentViewDelegate,
UIScrollViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, strong) EditMyInfoPresenter *presenter;

//@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL profileChanged;

@end

@implementation EditMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[EditMyInfoPresenter alloc] init];
    [self.presenter attachView:self];
    
    self.titleColor = [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:KUIColorFromRGB(0xf0f0f2)];
    self.VCTitleStr = @"资料详情";
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:RGBColor(251, 252, 255, 1) darkColor:UIColor.blackColor];
    self.backBtnImage = [UIImage imageNamed:@"navBar_back"];
    
    EditMyInfoContentView *contentView = [[EditMyInfoContentView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.delegate = self;
    contentView.contentScrollView.delegate = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.top.mas_equalTo(self.topBarView.mas_bottom);
    }];
}

- (void)dealloc
{
    [self.presenter dettatchView];
}


#pragma mark - scrollView代理回调
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - contentView代理回调
- (void)saveButtonClicked:(UIButton *)sender {
    [self.contentView.saveButton setTitle:@"上传中" forState:UIControlStateNormal];
    self.contentView.saveButton.userInteractionEnabled = NO;
    
    // 头像改变了才上传头像
    if (self.profileChanged) {
        [self.presenter uploadProfile:self.contentView.headerImageView.image Success:^{
            [self profileUploadSuccess:^{
                [self.presenter.attachedView userInfoUploadSuccess];
            } failure:^(NSError * _Nonnull error) {
                [self.presenter.attachedView userInfoOrProfileUploadFailure];
            }];
        } failure:^(NSError * _Nonnull error) {
            [self.presenter.attachedView userInfoOrProfileUploadFailure];
            [self profileUploadSuccess:^{} failure:^(NSError * _Nonnull error) {}];
        }];
    } else {
        // 头像没有改变，直接执行下一个任务
        [self profileUploadSuccess:^{
            [self.presenter.attachedView userInfoUploadSuccess];
        } failure:^(NSError * _Nonnull error) {
            [self.presenter.attachedView userInfoOrProfileUploadFailure];
        }];
    }
    
    if ([[UserItem defaultItem].qq isEqualToString:@"完善你的个人信息哦"]) {
        return;
    }
    if ([[UserItem defaultItem].nickname isEqualToString:@"student"]) {
        return;
    }
    if ([[UserItem defaultItem].introduction isEqualToString:@"完善你的个人信息哦"]) {
        return;
    }
    if ([[UserItem defaultItem].phone isEqualToString:@"完善你的个人信息哦"]) {
        return;
    }

    NSLog(@"完成完善个人信息任务");
    
    // 完成完善个人信息任务
    [HttpTool.shareTool
     form:Mine_POST_task_API
     type:HttpToolRequestTypePost
     parameters:nil
     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
        NSString *target = @"完善个人信息";
        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
        [body appendPartWithFormData:data name:@"title"];
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"成功了");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了");
    }];
}

- (void)headerImageTapped:(UIImageView *)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary< UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.contentView.headerImageView.image = image;
    self.profileChanged = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showUserInformationIntroduction:(UIButton *)sender {
    UserInformationIntorductionView *introductionView = [[UserInformationIntorductionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    [self.contentView addSubview:introductionView];
    
    introductionView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        introductionView.alpha = 1;
    }];
}


#pragma mark - Presenter回调
- (void)profileUploadSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSDictionary *uploadData = @{
        // 这三个字段不用了
        //@"stuNum": [UserDefaultTool getStuNum],
        //@"idNum": [UserDefaultTool getIdNum],
        //@"photo_src": [UserItemTool defaultItem].headImgUrl ? [UserItemTool defaultItem].headImgUrl : @"",
        @"nickname": self.contentView.nicknameTextField.text.length != 0 ? self.contentView.nicknameTextField.text : self.contentView.nicknameTextField.placeholder,
        @"introduction": self.contentView.introductionTextField.text,
        @"qq": self.contentView.QQTextField.text,
        @"phone": self.contentView.phoneNumberTextField.text,
        @"gender": self.contentView.genderTextField.text.length != 0 ? self.contentView.genderTextField.text : self.contentView.genderTextField.placeholder,
        @"birthday": self.contentView.birthdayTextField.text.length != 0 ? self.contentView.birthdayTextField.text : self.contentView.birthdayTextField.placeholder,
    };
    
    [self.presenter uploadUserInfo:uploadData Success:^{
        success();
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 修改数据失败之后执行这个方法
- (void)userInfoOrProfileUploadFailure {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"上传失败了...";
    [hud hide:YES afterDelay:1];
    
    [self.contentView.saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    self.contentView.saveButton.userInteractionEnabled = YES;
}

/// 修改数据成功之后执行这个方法
- (void)userInfoUploadSuccess {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 手势调用
- (void)slideToDismiss:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [self.contentView.contentScrollView.panGestureRecognizer locationInView:self.view];
    if (translatedPoint.y > 0) {
        //让我的页面控制器刷新数据
//        [((MineViewController *)self.transitioningDelegate) loadUserData];
//        ((MineViewController *)self.transitioningDelegate).panGesture = sender;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    self.contentView.contentScrollView
}

@end
