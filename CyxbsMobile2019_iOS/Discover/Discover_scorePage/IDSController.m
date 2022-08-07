//
//  IDSController.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "IDSController.h"
#import "IdsBindingView.h"
#import "IdsBinding.h"

@interface IDSController ()<IdsBindingViewDelegate>
@property(nonatomic, strong)IdsBindingView *idsBindgView;
@property (nonatomic, strong) IdsBinding * idsBindingModel;//ids绑定
@property (nonatomic, strong) MBProgressHUD *loadHud;
@end

@implementation IDSController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.idsBindgView;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(idsBindingSuccess) name:@"IdsBinding_Success" object:nil];
    
}

-(void)idsBindingSuccess {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) idsBindingError {
    [self.loadHud hide:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.idsBindgView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"绑定失败";
    [hud hide:YES afterDelay:1.0];
}

//MARK: - IdsBindingViewDelegate
- (void)touchBindingButton {
    NSString *bindingNum = self.idsBindgView.accountfield.text;
    NSString *bindingPasswd = self.idsBindgView.passTextfield.text;
    if(![bindingNum isEqual: @""] && ![bindingPasswd isEqual: @""]) {
        self.loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         self.loadHud.labelText = @"正在验证";
        IdsBinding *binding = [[IdsBinding alloc]initWithIdsNum:bindingNum isPassword:bindingPasswd];
        [binding fetchData];
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.idsBindgView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入统一认证码和密码呦～";
        [hud hide:YES afterDelay:2.0];
    }
}
- (IdsBindingView *)idsBindgView{
    if (!_idsBindgView) {
        _idsBindgView = [[IdsBindingView alloc] init];
        _idsBindgView.delegate = self;
    }
    return _idsBindgView;
}
@end
